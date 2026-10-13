"""Offline tests for unplug handling: ChannelWatcher, Hub inventory reconcile, and
the server dropping the USB/IP client when a device goes away.

Run: python3 -m unittest bridge.tests.test_unplug
"""
import socket
import threading
import time
import unittest

from bridge.sxuptp.client import ChannelWatcher, KeepaliveResponder
from bridge.usbip import protocol as u
from bridge.usbip import server as srv


class _Chan:
    """Stand-in for an SxuptpClient: the watcher only needs `.tcp`."""
    def __init__(self, sock):
        self.tcp = sock


def _wait(cond, secs=3.0):
    end = time.time() + secs
    while time.time() < end:
        if cond():
            return True
        time.sleep(0.01)
    return False


class WatcherTest(unittest.TestCase):
    def setUp(self):
        ChannelWatcher.POLL = 0.05
        self.a, self.b = socket.socketpair()      # a = our channel, b = the hub
        self.dead = []

    def tearDown(self):
        for s in (self.a, self.b):
            s.close()

    def _watch(self, *socks):
        return ChannelWatcher([_Chan(s) for s in socks], self.dead.append).start()

    def test_hub_fin_is_reported_once(self):
        self._watch(self.a)
        self.b.shutdown(socket.SHUT_RDWR)
        self.assertTrue(_wait(lambda: self.dead))
        time.sleep(0.2)
        self.assertEqual(len(self.dead), 1)
        self.assertIn("closed", self.dead[0])

    def test_pending_reply_is_not_an_unplug_and_is_not_consumed(self):
        self._watch(self.a)
        self.b.sendall(b"reply")
        time.sleep(0.3)
        self.assertEqual(self.dead, [])
        self.assertEqual(self.a.recv(5), b"reply")      # untouched by the watcher

    def test_reset_is_reported(self):
        import struct
        self._watch(self.a)
        self.b.setsockopt(socket.SOL_SOCKET, socket.SO_LINGER, struct.pack("ii", 1, 0))
        self.b.close()                                   # abortive close
        self.assertTrue(_wait(lambda: self.dead))

    def test_any_channel_of_a_composite_counts(self):
        c, d = socket.socketpair()
        try:
            self._watch(self.a, c)
            d.shutdown(socket.SHUT_RDWR)                 # only the second node dies
            self.assertTrue(_wait(lambda: self.dead))
        finally:
            c.close(); d.close()

    def test_stop_silences_our_own_teardown(self):
        w = self._watch(self.a)
        w.stop()
        self.a.close()                                   # we close it ourselves
        self.b.close()
        time.sleep(0.3)
        self.assertEqual(self.dead, [])


def _entry(port, name, vid, pid):
    return {"port": port, "device": name, "vid": vid, "pid": pid}


KB1, KB2 = _entry("dev02", "Keyboard", 0x0C45, 0x8603), _entry("dev03", "Keyboard", 0x0C45, 0x8603)
FLASH = _entry("dev01", "Flash", 0x1B1C, 0x1A15)
SER = _entry("dev04", "Serial", 0x067B, 0x2303)


def _hub(listed):
    h = srv.Hub.__new__(srv.Hub)                         # no network
    h.host, h.client_ip, h.mac = "h", "c", b"\0" * 6
    h._session = h._grant = None
    h.attach_lock = threading.Lock()
    h._claim_lock = threading.Lock()
    h._claimed, h.devices, h.names, h._node_busid = set(), {}, {}, {}
    h._last_refresh = 0.0
    h._reconcile(listed)
    return h


class ReconcileTest(unittest.TestCase):
    def test_initial_inventory_and_composite_siblings(self):
        h = _hub([FLASH, KB1, KB2, SER])
        self.assertEqual({b: d.node for b, d in h.devices.items()},
                         {"1-1": "dev01", "1-2": "dev02", "1-3": "dev03", "1-4": "dev04"})
        self.assertEqual(h.devices["1-2"].siblings, ("dev02", "dev03"))

    def test_unplug_hides_device_and_replug_restores_the_same_busid(self):
        h = _hub([FLASH, KB1, KB2, SER])
        h._reconcile([KB1, KB2, SER])                    # flash unplugged
        self.assertFalse(h.devices["1-1"].present)
        self.assertNotIn("1-1", [d.busid for d in h.devlist()])
        h._reconcile([FLASH, KB1, KB2, SER])             # plugged back
        self.assertTrue(h.devices["1-1"].present)
        self.assertEqual(len(h.devices), 4)

    def test_moved_device_gets_a_free_busid_and_old_one_stays_hidden(self):
        h = _hub([FLASH, SER])
        moved = _entry("dev07", "Flash", 0x1B1C, 0x1A15)  # same drive, new node
        h._reconcile([moved, SER])
        self.assertFalse(h.devices["1-1"].present)
        self.assertEqual(h.devices["1-3"].node, "dev07")  # lowest UNUSED busid
        self.assertTrue(h.devices["1-3"].present)

    def test_different_device_on_a_free_node_is_repointed(self):
        h = _hub([FLASH, SER])
        h._reconcile([_entry("dev01", "Other", 0x1234, 0x5678), SER])
        d = h.devices["1-1"]
        self.assertEqual((d.vid, d.pid), (0x1234, 0x5678))
        self.assertEqual(h.names["1-1"], "Other")

    def test_imported_device_identity_is_not_changed_underneath_a_client(self):
        h = _hub([FLASH, SER])
        h.devices["1-1"].in_use = True
        h._reconcile([_entry("dev01", "Other", 0x1234, 0x5678), SER])
        self.assertEqual((h.devices["1-1"].vid, h.devices["1-1"].pid), (0x1B1C, 0x1A15))

    def test_empty_list_hides_everything(self):
        h = _hub([FLASH, SER])
        h._reconcile([])
        self.assertEqual(h.devlist(), [])


class RefreshTest(unittest.TestCase):
    """Hub.refresh() must not hide a device because of one short/empty reply."""

    def _refresh_with(self, h, *replies):
        seq = list(replies)
        h._query_list = lambda retries=2: seq.pop(0)
        h._CONFIRM_DELAY = 0
        h._last_refresh = 0.0
        h.refresh()
        return seq

    def test_one_empty_reply_does_not_hide_anything(self):
        h = _hub([FLASH, KB1, KB2, SER])
        left = self._refresh_with(h, [], [FLASH, KB1, KB2, SER])
        self.assertEqual(left, [])
        self.assertTrue(all(d.present for d in h.devices.values()))

    def test_two_consistent_replies_do_hide_it(self):
        h = _hub([FLASH, KB1, KB2, SER])
        self._refresh_with(h, [KB1, KB2, SER], [KB1, KB2, SER])
        self.assertFalse(h.devices["1-1"].present)

    def test_no_second_query_when_nothing_is_missing(self):
        h = _hub([FLASH, SER])
        left = self._refresh_with(h, [FLASH, SER, KB1])
        self.assertEqual(left, [])
        self.assertTrue(h.devices["1-3"].present)           # newly seen: immediate

    def test_unanswered_query_leaves_inventory_alone(self):
        h = _hub([FLASH, SER])
        self._refresh_with(h, None)
        self.assertTrue(all(d.present for d in h.devices.values()))


class _FakeDev:
    busid, node, vid, pid, in_use, present = "1-1", "dev01", 1, 2, False, True
    siblings = ("dev01",)
    names = {}

    def __init__(self):
        self.on_gone = None
        self.detached = threading.Event()

    def attach(self):
        return u.UsbipDevice(busid="1-1", busnum=1, devnum=1, id_vendor=1, id_product=2,
                             b_num_interfaces=1, interfaces=[(8, 6, 80)])

    def watch(self, cb):
        self.on_gone = cb

    def detach(self):
        self.detached.set()

    def is_async(self, cmd):
        return False

    def submit(self, cmd):
        return 0, b""


class _FakeHub:
    def __init__(self, dev):
        self.dev, self.devices, self.names = dev, {"1-1": dev}, {"1-1": "fake"}
        self.refreshes = 0
        self.released = threading.Event()

    def refresh(self): self.refreshes += 1
    def devlist(self): return []
    def reserve(self, dev): dev.in_use = True; return None
    def release(self, dev): dev.in_use = False; self.released.set()


class ServerUnplugTest(unittest.TestCase):
    def test_client_is_disconnected_and_device_released_when_the_hub_drops_it(self):
        dev = _FakeDev()
        hub = _FakeHub(dev)
        server = srv.Server(("127.0.0.1", 0), srv.Handler)
        server.hub = hub
        threading.Thread(target=server.serve_forever, daemon=True).start()
        try:
            c = socket.create_connection(server.server_address)
            c.settimeout(3)
            c.sendall(u.pack_op_header(u.OP_REQ_IMPORT) + b"1-1".ljust(32, b"\0"))
            reply = c.recv(4096)
            self.assertEqual(u.parse_op_header(reply)[2], 0)          # import OK
            self.assertTrue(_wait(lambda: dev.on_gone is not None))
            self.assertEqual(hub.refreshes, 1)                        # refreshed on import
            dev.on_gone("hub closed the channel")                     # the unplug
            self.assertEqual(c.recv(16), b"")                         # server hung up
            self.assertTrue(dev.detached.wait(3))
            self.assertTrue(hub.released.wait(3))                     # busid is free again
            c.close()
        finally:
            server.shutdown()
            server.server_close()

    def test_import_of_an_unplugged_busid_is_refused(self):
        dev = _FakeDev()
        dev.present = False
        hub = _FakeHub(dev)
        server = srv.Server(("127.0.0.1", 0), srv.Handler)
        server.hub = hub
        threading.Thread(target=server.serve_forever, daemon=True).start()
        try:
            c = socket.create_connection(server.server_address)
            c.settimeout(3)
            c.sendall(u.pack_op_header(u.OP_REQ_IMPORT) + b"1-1".ljust(32, b"\0"))
            self.assertEqual(c.recv(4096), u.pack_import_reply(None))
            c.close()
        finally:
            server.shutdown()
            server.server_close()


class KeepaliveHealthTest(unittest.TestCase):
    """The one host-level keepalive responder must recover if its receive thread
    dies, or the hub RSTs every data channel ~69s later (see Hub._health_loop)."""

    LOOP = "127.0.0.1"

    def _echoes(self, ka, peer, secs=4.0):
        """True if a ping to the responder's port comes back within `secs`."""
        peer.settimeout(0.3)
        end = time.time() + secs
        while time.time() < end:
            try:
                peer.sendto(ka.PING, (self.LOOP, ka.PORT))
                if peer.recvfrom(64)[0] == ka.PING:
                    return True
            except (OSError, socket.timeout):
                pass
            time.sleep(0.1)
        return False

    def test_restart_rebinds_after_the_receive_thread_dies(self):
        ka = KeepaliveResponder(self.LOOP, self.LOOP)
        self.assertTrue(ka.start(), ka.error)
        try:
            ka._sock.close()                       # simulate a socket error in _loop
            self.assertTrue(_wait(lambda: not ka.running))
            self.assertTrue(ka.restart(), ka.error)
            self.assertTrue(ka.running)
            peer = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            peer.bind((self.LOOP, 0))
            self.addCleanup(peer.close)
            self.assertTrue(self._echoes(ka, peer))
        finally:
            ka.stop()

    def test_hub_health_loop_recovers_a_dead_responder(self):
        hub = srv.Hub.__new__(srv.Hub)            # bypass discovery; wire just enough
        hub.keepalive = KeepaliveResponder(self.LOOP, self.LOOP)
        hub._HEALTH_POLL = 0.05
        self.assertTrue(hub.keepalive.start(), hub.keepalive.error)
        hub._start_health()
        peer = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        peer.bind((self.LOOP, 0))
        self.addCleanup(peer.close)
        try:
            self.assertTrue(self._echoes(hub.keepalive, peer, 2.0))   # healthy first
            hub.keepalive._sock.close()                               # kill the thread
            # the port is unbound until the health loop restarts it; an echo
            # returning again proves the loop detected the death and rebound.
            self.assertTrue(self._echoes(hub.keepalive, peer, 4.0))
            self.assertTrue(hub.keepalive.running)
        finally:
            hub._stop_health.set()
            hub.keepalive.stop()


if __name__ == "__main__":
    unittest.main()
