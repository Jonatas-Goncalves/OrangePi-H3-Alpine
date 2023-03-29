#!/bin/sh

source ./env.sh

TMP=$(mktemp -d)
mkdir $TMP/root

cleanup() {
	echo "Remove $TMP"
	rm -rf $TMP
}

trap cleanup EXIT

cp $ALPINE_BUILD/boot/initramfs-lts $TMP

(cd $TMP/root && gunzip -c $TMP/initramfs-lts | cpio -i)

cp -r $LINUX_BUILD/out/modules/lib/modules/* $TMP/root/lib/modules
mkdir -p $TMP/root/lib/firmware/rtlwifi
cp -r RTLWIFI/rtl8188fufw.bin $TMP/root/lib/firmware/rtlwifi/

zipped_ramfs=$TMP/initramfs-lts
(cd $TMP/root && find . | cpio -H newc -o | gzip -9 > $zipped_ramfs)
mkimage -n initramfs-sunxi -A arm -O linux -T ramdisk -C none -d $zipped_ramfs $DEST_DIR/initramfs
