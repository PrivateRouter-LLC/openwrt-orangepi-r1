#!/bin/bash

OUTPUT="$(pwd)/images"
BUILD_VERSION="22.03.2"
BUILDER="https://downloads.openwrt.org/releases/${BUILD_VERSION}/targets/sunxi/cortexa7/openwrt-imagebuilder-${BUILD_VERSION}-sunxi-cortexa7.Linux-x86_64.tar.xz"
KERNEL_PARTSIZE=128 #Kernel-Partitionsize in MB
ROOTFS_PARTSIZE=4096 #Rootfs-Partitionsize in MB
BASEDIR=$(realpath "$0" | xargs dirname)

# download image builder
if [ ! -f "${BUILDER##*/}" ]; then
	wget "$BUILDER"
	tar xJvf "${BUILDER##*/}"
fi

[ -d "${OUTPUT}" ] || mkdir "${OUTPUT}"

cd openwrt-*/

# clean previous images
make clean

# Packages are added if no prefix is given, '-packaganame' does not integrate a package
sed -i "s/CONFIG_TARGET_KERNEL_PARTSIZE=.*/CONFIG_TARGET_KERNEL_PARTSIZE=$KERNEL_PARTSIZE/g" .config
sed -i "s/CONFIG_TARGET_ROOTFS_PARTSIZE=.*/CONFIG_TARGET_ROOTFS_PARTSIZE=$ROOTFS_PARTSIZE/g" .config

make image  PROFILE="xunlong_orangepi-r1" \
           PACKAGES="kmod-rt2800-usb rt2800-usb-firmware kmod-cfg80211 kmod-lib80211 kmod-mac80211 kmod-rtl8192cu \
                     docker docker-compose dockerd luci-app-dockerman luci-lib-docker \
                     base-files block-mount fdisk luci-app-minidlna minidlna samba4-server \
                     samba4-libs luci-app-samba4 wireguard-tools luci-app-wireguard \
                     openvpn-openssl luci-app-openvpn watchcat openssh-sftp-client \
                     luci-base luci-ssl luci-mod-admin-full luci-theme-bootstrap \
                     kmod-usb-storage kmod-usb-ohci kmod-usb-uhci e2fsprogs fdisk resize2fs \
                     htop debootstrap luci-compat luci-lib-ipkg dnsmasq luci-app-ttyd \
                     irqbalance ethtool netperf speedtest-netperf iperf3 \
                     curl wget rsync file htop lsof less mc tree usbutils bash diffutils \
                     openssh-sftp-server nano luci-app-ttyd kmod-fs-exfat \
                     kmod-usb-storage block-mount luci-app-minidlna kmod-fs-ext4 \
                     urngd usign vpn-policy-routing wg-installer-client wireguard-tools \
                     kmod-usb-core kmod-usb3 dnsmasq dropbear e2fsprogs \
                     zlib wireless-regdb f2fsck openssh-sftp-server \
                     kmod-usb-wdm kmod-usb-net-ipheth usbmuxd \
                     kmod-usb-net-cdc-ether mount-utils kmod-rtl8xxxu kmod-rtl8187 \
                     kmod-rtl8xxxu rtl8188eu-firmware kmod-rtl8192cu \
                     adblock luci-app-adblock luci-app-commands kmod-fs-squashfs squashfs-tools-unsquashfs squashfs-tools-mksquashfs \
                     kmod-fs-f2fs kmod-fs-vfat git git-http jq" \
            FILES="${BASEDIR}/files/" \
            BIN_DIR="${OUTPUT}"
