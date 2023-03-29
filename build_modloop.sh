#!/bin/sh

source ./env.sh

TMP=$(mktemp -d)
mkdir $TMP/root

cleanup() {
	echo "Remove $TMP"
	rm -rf $TMP
}

trap cleanup EXIT

cp $ALPINE_BUILD/boot/modloop-lts $TMP

(cd $TMP/root && unsquashfs ../modloop-lts)

rm -r $TMP/root/squashfs-root/modules/*-lts
cp -r $LINUX_BUILD/out/modules/lib/modules/* $TMP/root/squashfs-root/modules/

rm -r $TMP/root/squashfs-root/modules/firmware/*
mkdir -p $TMP/root/squashfs-root/modules/firmware/rtlwifi
cp -r RTLWIFI/*.bin $TMP/root/squashfs-root/modules/firmware/rtlwifi

(cd $TMP/root && mksquashfs squashfs-root/ modloop-new -b 1048576 -comp xz -Xdict-size 100%)

cp $TMP/root/modloop-new $DEST_DIR/modloop

