#!/usr/bin/env bash
# Watches for a UF2 bootloader volume and flashes the halves in order: left, then right.
#
# The nRF52840 does not enter its bootloader just by being plugged in -- double-press
# the reset button on the underside of the half you have just connected, and it mounts
# as a drive with INFO_UF2.TXT on it. This script does the rest.
#
# Order is positional, not detected: the first volume to appear gets the left image,
# the second gets the right. Plug and reset left first.
set -uo pipefail

cd "$(dirname "$0")"
FW=firmware
ORDER=(left right)
IDX=0

find_uf2_volume() {
  for v in /Volumes/*; do
    [ -f "$v/INFO_UF2.TXT" ] && { printf '%s' "$v"; return 0; }
  done
  return 1
}

echo "Waiting for a UF2 volume. Plug in the LEFT half, then double-press its reset button."
echo "(Ctrl-C to stop.)"

while [ "$IDX" -lt "${#ORDER[@]}" ]; do
  side="${ORDER[$IDX]}"
  img="$FW/corne_choc_pro_${side}-zmk.uf2"

  if [ ! -f "$img" ]; then
    echo "MISSING: $img -- nothing to flash. Stopping." >&2
    exit 1
  fi

  # Wait for a volume to appear.
  until vol="$(find_uf2_volume)"; do sleep 1; done

  echo ""
  echo "--> $(basename "$vol") detected. Flashing ${side}: $(basename "$img")"
  head -1 "$vol/INFO_UF2.TXT" 2>/dev/null | sed 's/^/    /'

  if cp "$img" "$vol"/; then
    sync
    echo "    copied. The half reboots on its own and the volume disappears."
  else
    echo "    COPY FAILED -- retry the double-reset and it will be picked up again." >&2
    continue
  fi

  # Wait for it to unmount before looking for the next half, so one volume is
  # never counted twice.
  while find_uf2_volume >/dev/null; do sleep 1; done
  echo "    ${side} done."

  IDX=$((IDX + 1))
  if [ "$IDX" -lt "${#ORDER[@]}" ]; then
    echo ""
    echo "Now plug in the RIGHT half and double-press its reset button."
  fi
done

echo ""
echo "Both halves flashed."
