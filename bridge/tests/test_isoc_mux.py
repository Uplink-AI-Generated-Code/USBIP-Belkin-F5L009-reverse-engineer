"""Offline tests for isochronous IN through ChannelMux, against a fake hub.

Run: python3 -m unittest bridge.tests.test_isoc_mux
"""
import socket
import struct
import threading
import unittest

from bridge.sxuptp import protocol as p
from bridge.sxuptp.client import ChannelMux, ISOC_PKT_ERR, SxuptpClient

EP = 0x81


def _reply(seq: int, packets: list[bytes], pkt_status: int = 0) -> bytes:
    """A hub isoc reply: 10-byte header, count, table, concatenated payload."""
    table, off = b"", 0
    for d in packets:
        table += struct.pack(">III", off, len(d), pkt_status)
        off += len(d)
    body = struct.pack(">H", len(packets)) + table + b"".join(packets)
    return struct.pack(">HHHHH", 0x0004, seq, 0, 0, len(body)) + body


class FakeHub:
    """Reads isoc requests off a socket and replies per `respond(seq, lengths)`."""

    def __init__(self, sock, respond, hold=False):
        self.sock, self.respond, self.hold = sock, respond, hold
        self.requests = []                      # (seq, [lengths]) as received
        self.held = []                          # replies withheld while `hold`
        self.hold = hold
        self.lock = threading.Lock()
        threading.Thread(target=self._run, daemon=True).start()

    def _recvn(self, n):
        b = b""
        while len(b) < n:
            c = self.sock.recv(n - len(b))
            if not c:
                raise EOFError
            b += c
        return b

    def _run(self):
        try:
            while True:
                hdr = self._recvn(24)
                assert struct.unpack_from(">H", hdr, 0)[0] == 0x0004
                seq = struct.unpack_from(">H", hdr, 2)[0]
                n = struct.unpack_from(">H", hdr, 16)[0]
                descs = self._recvn(12 * n)
                lengths = [struct.unpack_from(">I", descs, 12 * i + 4)[0] for i in range(n)]
                self.requests.append((seq, lengths))
                reply = self.respond(seq, lengths)
                with self.lock:
                    if self.hold:
                        self.held.append(reply)
                        continue
                self.sock.sendall(reply)
        except (EOFError, OSError):
            pass


    def release(self):
        """Stop withholding replies and send the ones held, in order."""
        with self.lock:
            self.hold = False
            held, self.held = self.held, []
        for r in held:
            self.sock.sendall(r)


def make_mux(respond, hold=False):
    a, b = socket.socketpair()
    c = SxuptpClient("127.0.0.1")
    c.tcp, c.dev_id, c._rxbuf, c.seq = a, 6, b"", 0
    hub = FakeHub(b, respond, hold)
    mux = ChannelMux(c)
    mux.register_isoc_in(EP)
    return mux, hub, a


class IsocMuxTest(unittest.TestCase):
    def test_single_request_roundtrip(self):
        mux, hub, _ = make_mux(lambda seq, ls: _reply(seq, [b"a" * 4, b"", b"b" * 2]))
        done = threading.Event()
        out = []
        mux.enqueue_isoc(EP, "urb", lambda u, st, pk: (out.append((st, pk)), done.set()),
                         [1024, 1024, 1024])
        self.assertTrue(done.wait(2))
        self.assertEqual(out[0], (0, [(0, 4, b"aaaa"), (0, 0, b""), (0, 2, b"bb")]))
        self.assertEqual(hub.requests[0][1], [1024, 1024, 1024])
        mux.close()

    def test_large_urb_is_chunked_and_reassembled_in_order(self):
        # 32 x 3072 cannot come back in one u16-sized reply
        def respond(seq, ls):
            return _reply(seq, [bytes([seq & 0xFF]) * 3 for _ in ls])
        mux, hub, _ = make_mux(respond)
        done, out = threading.Event(), []
        mux.enqueue_isoc(EP, "urb", lambda u, st, pk: (out.append(pk), done.set()),
                         [3072] * 32)
        self.assertTrue(done.wait(2))
        self.assertGreater(len(hub.requests), 1)
        self.assertEqual(sum(len(ls) for _s, ls in hub.requests), 32)
        pk = out[0]
        self.assertEqual(len(pk), 32)
        # each packet carries the seq byte of the chunk request that served it
        want = []
        for seq, ls in hub.requests:
            want += [bytes([seq & 0xFF]) * 3] * len(ls)
        self.assertEqual([d for _s, _a, d in pk], want)
        mux.close()

    def test_requests_are_pipelined_before_any_reply(self):
        mux, hub, _ = make_mux(lambda seq, ls: _reply(seq, [b"x"] * len(ls)), hold=True)
        dones = [threading.Event() for _ in range(3)]
        for i in range(3):
            mux.enqueue_isoc(EP, i, lambda u, st, pk: dones[u].set(), [64] * 4)
        for _ in range(100):                      # all three on the wire, none answered
            if len(hub.requests) == 3:
                break
            threading.Event().wait(0.02)
        self.assertEqual(len(hub.requests), 3)
        self.assertFalse(any(d.is_set() for d in dones))
        hub.release()
        self.assertTrue(all(d.wait(2) for d in dones))
        mux.close()

    def test_cancel_drops_completion_but_connection_survives(self):
        mux, hub, _ = make_mux(lambda seq, ls: _reply(seq, [b"x"] * len(ls)), hold=True)
        called = []
        mux.enqueue_isoc(EP, "gone", lambda u, st, pk: called.append(u), [64] * 2)
        for _ in range(100):
            if hub.requests:
                break
            threading.Event().wait(0.02)
        self.assertTrue(mux.cancel_urb(EP, "gone"))
        done = threading.Event()
        mux.enqueue_isoc(EP, "next", lambda u, st, pk: (called.append(u), done.set()), [64])
        hub.release()
        self.assertTrue(done.wait(2))
        self.assertEqual(called, ["next"])        # cancelled reply swallowed
        self.assertFalse(mux.cancel_urb(EP, "next"))   # already completed
        mux.close()

    def test_bad_hub_status_marks_packets_errored(self):
        mux, _, _ = make_mux(lambda seq, ls: struct.pack(">HHHHH", 4, seq, 0xFFFF, 0, 0))
        done, out = threading.Event(), []
        mux.enqueue_isoc(EP, "urb", lambda u, st, pk: (out.append((st, pk)), done.set()),
                         [64, 64])
        self.assertTrue(done.wait(2))
        self.assertEqual(out[0], (0, [(ISOC_PKT_ERR, 0, b"")] * 2))
        mux.close()

    def test_per_packet_error_status_is_reported(self):
        mux, _, _ = make_mux(lambda seq, ls: _reply(seq, [b""] * len(ls), pkt_status=3))
        done, out = threading.Event(), []
        mux.enqueue_isoc(EP, "urb", lambda u, st, pk: (out.append(pk), done.set()), [64])
        self.assertTrue(done.wait(2))
        self.assertEqual(out[0], [(ISOC_PKT_ERR, 0, b"")])
        mux.close()

    def test_channel_death_fails_pending_urbs(self):
        mux, hub, _ = make_mux(lambda seq, ls: b"", hold=True)
        done, out = threading.Event(), []
        mux.enqueue_isoc(EP, "urb", lambda u, st, pk: (out.append((st, pk)), done.set()), [64])
        hub.sock.close()
        self.assertTrue(done.wait(2))
        self.assertNotEqual(out[0][0], 0)
        mux.close()


if __name__ == "__main__":
    unittest.main()
