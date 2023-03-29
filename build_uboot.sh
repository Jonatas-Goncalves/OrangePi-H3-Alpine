#!/bin/sh

source ./env.sh

cd $UBOOT_BUILD
export PATH=$PATH:/$TOOLCHAIN

echo "Compiling U-Boot for OrangePi H3 model: $DEFCONFIG_CONF"

export CROSS_COMPILE=arm-linux-gnueabihf-
make $DEFCONFIG_CONF

sed -i "s/CONFIG_BOOTDELAY=2/CONFIG_BOOTDELAY=1/g" .config
sed -i "s/# CONFIG_USB_EHCI_HCD is not set/CONFIG_USB_EHCI_HCD=y/g" .config
sed -i "s/# CONFIG_USB_OHCI_HCD is not set/CONFIG_USB_OHCI_HCD=y/g" .config

make olddefconfig
make -j4

cd "$OLDPWD"
cp $UBOOT_BUILD/u-boot-sunxi-with-spl.bin $DEST_DIR

