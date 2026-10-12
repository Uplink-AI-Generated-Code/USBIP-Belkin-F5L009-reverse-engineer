#!/usr/bin/env bash
# Recover the hub after a wedged run: HTTP-reboot it (clears a stuck SXUPTP slot)
# and, if the usbip test container is running, free any stuck vhci port.
#
#   ./recover.sh [HUB_IP]
#
# The HTTP reboot is the one that matters for the direct SXUPTP tests (it clears
# the slot that a wedged write leaves reserved). Comes back in ~10-15 s.
set -u
HUB="${1:-192.168.2.3}"

echo "[recover] HTTP login + reboot $HUB ..."
curl -s -m 5 -o /dev/null -w "  login:%{http_code}\n"  --data "login_password=" "http://$HUB/en/login/login.htm"
curl -s -m 5 -o /dev/null -w "  reboot:%{http_code}\n" "http://$HUB/en/reset/exec.htm"

# If the Linux usbip test container is up, free any stuck vhci port (harmless if
# there is none). Only relevant when you've also been using the vhci/usbip path.
if command -v docker >/dev/null && docker ps --format '{{.Names}}' 2>/dev/null | grep -qx usbiptest; then
  echo "[recover] freeing any stuck vhci ports in container 'usbiptest' ..."
  docker exec usbiptest bash -c 'for p in 0 1 2 3; do echo $p > /sys/devices/platform/vhci_hcd.0/detach 2>/dev/null; done' || true
fi

echo "[recover] waiting 14s for the hub to come back ..."
sleep 14
echo "[recover] done. (If a test then says 'no SXUPTP hub answered discovery', wait a few more seconds and retry.)"
