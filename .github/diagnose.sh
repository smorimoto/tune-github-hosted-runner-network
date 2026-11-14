#!/usr/bin/env bash
set -u

route_devs() {
  ip -o "$@" route show default 2>/dev/null | sed -n 's/.* dev \([^ ]*\).*/\1/p' | sort -u | paste -sd, -
}

echo "SUMMARY image=${ImageOS:-?}-${ImageVersion:-?} arch=$(uname -m) kernel=$(uname -r) systemd=$(systemctl --version 2>/dev/null | awk 'NR==1{print $2}') eth0=$([ -e /sys/class/net/eth0 ] && echo present || echo absent) default4=$(route_devs -4) default6=$(route_devs -6) gemini_awk=$(ip route show default | awk '{print $5; exit}')"

for path in /sys/class/net/*; do
  name=${path##*/}
  driver=none
  [ -e "$path/device/driver" ] && driver=$(basename "$(readlink -f "$path/device/driver")")
  master=none
  [ -e "$path/master" ] && master=$(basename "$(readlink -f "$path/master")")
  altnames=$(ip -o link show dev "$name" | grep -o 'altname [^ \\]*' | awk '{print $2}' | paste -sd, -)
  echo "IFACE name=$name device=$([ -e "$path/device" ] && echo yes || echo no) driver=$driver operstate=$(cat "$path/operstate") master=$master altnames=${altnames:-none}"
done

echo "::group::ip -d link"
ip -d link
echo "::endgroup::"

echo "::group::addresses and routes"
ip -br addr
ip route
ip -6 route
echo "::endgroup::"

echo "::group::networkd and netplan"
networkctl list --no-pager
ls -la /etc/netplan /etc/systemd/network /run/systemd/network /usr/lib/systemd/network 2>&1
sudo sh -c 'cat /etc/netplan/*.yaml' 2>&1
echo "::endgroup::"

echo "::group::udev"
for path in /sys/class/net/*; do
  [ -e "$path/device" ] && udevadm info "$path"
done
echo "::endgroup::"

echo "::group::kernel log"
sudo dmesg | grep -iE 'renamed|hv_netvsc|mlx|virtio_net|eth[0-9]' | head -60
echo "::endgroup::"

echo "::group::offload state before"
for path in /sys/class/net/*; do
  [ -e "$path/device" ] || continue
  name=${path##*/}
  echo "== $name"
  sudo ethtool -i "$name"
  sudo ethtool -k "$name" | grep -E '^(rx-checksumming|tx-checksumming|tcp-segmentation-offload|generic-segmentation-offload|generic-receive-offload):'
done
echo "::endgroup::"

exit 0
