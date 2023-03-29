#!/bin/sh

source ./env.sh

cd $LINUX_BUILD
export PATH=$PATH:/$TOOLCHAIN
export DTC_FLAGS=-@

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-

# Configure build
make sunxi_defconfig
sed -i "s/# CONFIG_SQUASHFS is not set/CONFIG_SQUASHFS=y/g" .config
sed -i "s/# CONFIG_BLK_DEV_LOOP is not set/CONFIG_BLK_DEV_LOOP=y/g" .config
sed -i "s/# CONFIG_WLAN is not set/CONFIG_WLAN=y/g" .config
sed -i "s/# CONFIG_RTL8XXXU is not set/CONFIG_RTL8XXXU=y/g" .config
echo "CONFIG_CFG80211=y" >> .config
echo "CONFIG_CFG80211_WEXT=y" >> .config
echo "CONFIG_MAC80211=y" >> .config
echo "CONFIG_RTLWIFI=m" >> .config

make olddefconfig

sed -i "s/# CONFIG_SQUASHFS_XZ is not set/CONFIG_SQUASHFS_XZ=y/g" .config

# Start building
make -j4 zImage dtbs
INSTALL_MOD_PATH=out/modules make modules modules_install

cd "$OLDPWD"

# Copy output
cp $LINUX_BUILD/arch/arm/boot/zImage $DEST_DIR
cp $LINUX_BUILD/arch/arm/boot/dts/$DTB_FILE $DEST_DIR