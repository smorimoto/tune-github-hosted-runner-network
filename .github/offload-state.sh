#!/usr/bin/env bash
set -u

phase=$1
status=0

for path in /sys/class/net/*; do
  [ -e "$path/device" ] || continue
  name=${path##*/}
  driver=$(basename "$(readlink -f "$path/device/driver")")
  master=none
  [ -e "$path/master" ] && master=$(basename "$(readlink -f "$path/master")")
  features=$(sudo ethtool -k "$name")
  rx=$(awk '$1 == "rx-checksumming:" {print $2}' <<<"$features")
  tx=$(awk '$1 == "tx-checksumming:" {print $2}' <<<"$features")
  echo "$phase image=${ImageOS:-?}-${ImageVersion:-?} kernel=$(uname -r) name=$name driver=$driver master=$master rx=$rx tx=$tx"
  if [ "$phase" = AFTER ] && [ "$master" = none ] && { [ "$rx" != off ] || [ "$tx" != off ]; }; then
    echo "::error::checksum offload is still on for $name"
    status=1
  fi
done

exit $status
