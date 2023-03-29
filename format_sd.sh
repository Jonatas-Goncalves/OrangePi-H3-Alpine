#!/bin/sh

lsblk
echo
echo
echo "***WARNING*** pay attention or you can format the wrong device!!!"
echo

read -p "Which device do you want to use? (ex: /dev/sdd) " DEV
echo "umount partitions in ${DEV}..."

sudo umount ${DEV}*

#Flash u-Boot on firts SD Card Partition
sudo dd if=/dev/zero of=$DEV bs=1M count=1
sudo dd if=bin/u-boot-sunxi-with-spl.bin of=$DEV bs=1024 seek=8

#Create partitions to flash Alpine
sudo sfdisk $DEV < disk_layout.sfdisk
echo "y" | sudo mkfs.fat ${DEV}1
echo "y" | sudo mkfs.ext4 ${DEV}2
echo "y" | sudo mkfs.ext4 ${DEV}3
sync

#Make directories and copy files to SD Card
TMPDIR=$(mktemp -d)
sudo mount ${DEV}1 $TMPDIR
sudo mkdir -p ${TMPDIR}/boot/dtbs
sudo mkdir -p ${TMPDIR}/boot/dtbs/overlay
sudo cp bin/boot.scr ${TMPDIR}/boot
sudo cp bin/alpineEnv.txt ${TMPDIR}/boot
#get UUID of formated SD Card to write on alpineEnv
UUID=$(sudo blkid -o value -s UUID $DEV)
sudo sed -i "6s/.*/rootdev=UUID=$UUID/" ${TMPDIR}/boot/alpineEnv.txt
sudo cp bin/sun8i*.dtb ${TMPDIR}/boot/dtbs
sudo cp bin/overlay/* ${TMPDIR}/boot/dtbs/overlay
sudo cp bin/initramfs ${TMPDIR}/boot
sudo cp bin/modloop ${TMPDIR}/boot
sudo cp bin/zImage ${TMPDIR}/boot/zImage
sudo cp -r build/alpine/apks/ ${TMPDIR}/
sudo umount ${DEV}1
rmdir $TMPDIR

sync
