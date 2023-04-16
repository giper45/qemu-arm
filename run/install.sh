#!/usr/bin/env bash
set -eu

TMP="/boot.img"
rm -f "$TMP"

echo "Downloading ${BOOT}..."

# Check if running with interactive TTY or redirected to docker log
if [ -t 1 ]; then
  wget "$BOOT" -O "$TMP" -q --no-check-certificate --show-progress --progress=bar:noscroll
else
  wget "$BOOT" -O "$TMP" -q --no-check-certificate --show-progress --progress=dot:giga
fi

[ ! -f "$TMP" ] && echo "Failed to download ${BOOT}" && exit 61

SIZE=$(stat -c%s "$TMP")

if ((SIZE<1000000)); then
  echo "Invalid ISO file: Size is smaller than 1 MB." && exit 62
fi

FILE="$STORAGE/boot.img"

mv -f "$TMP" "$FILE"