#!/bin/sh

source ./env.sh

cd $LINUX_BUILD"2"
export PATH=$PATH:/$TOOLCHAIN
export DTC_FLAGS=-@

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-

# Configure build
make sunxi_defconfig
sed -i "s/# CONFIG_SQUASHFS is not set/CONFIG_SQUASHFS=y/g" .config
sed -i "s/# CONFIG_BLK_DEV_LOOP is not set/CONFIG_BLK_DEV_LOOP=y/g" .config
sed -i "s/# CONFIG_WLAN is not set/CONFIG_WLAN=y/g" .config
echo "CONFIG_CFG80211=y" >> .config
echo "CONFIG_CFG80211_WEXT=y" >> .config
echo "CONFIG_MAC80211=y" >> .config
echo "CONFIG_RTLWIFI=m" >> .config
sed -i "s/# CONFIG_SND_SUN8I_CODEC is not set/CONFIG_SND_SUN8I_CODEC=y/g" .config
sed -i "s/# CONFIG_SUN4I_GPADC is not set/CONFIG_SUN4I_GPADC=y/g" .config
sed -i "s/# CONFIG_SUN8I_THS is not set/CONFIG_SUN8I_THS=y/g" .config
# sed -i "s/# CONFIG_SENSORS_IIO_HWMON is not set/CONFIG_SENSORS_IIO_HWMON=y/g" .config
sed -i "s/# CONFIG_SND_SUN8I_CODEC_ANALOG is not set/CONFIG_SND_SUN8I_CODEC_ANALOG=y/g" .config
sed -i "s/CONFIG_INPUT_TOUCHSCREEN=y/# CONFIG_INPUT_TOUCHSCREEN is not set/g" .config
sed -i "s/# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set/CONFIG_CPU_FREQ_GOV_ONDEMAND=y/g" .config
sed -i "s/# CONFIG_CPU_FREQ_GOV_CONSERVATIVE is not set/CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y/g" .config
sed -i "s/# CONFIG_CPU_FREQ_GOV_ONDEMAND is not set/CONFIG_CPU_FREQ_GOV_ONDEMAND=y/g" .config
sed -i "s/CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y/# CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE is not set/g" .config
sed -i "s/# CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set/CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND=y/g" .config

make olddefconfig

sed -i "s/# CONFIG_MFD_SUN4I_GPADC is not set/CONFIG_MFD_SUN4I_GPADC=y/g" .config
sed -i "s/# CONFIG_SQUASHFS_XZ is not set/CONFIG_SQUASHFS_XZ=y/g" .config

# Start building
make -j4 zImage dtbs
INSTALL_MOD_PATH=out/modules make modules modules_install

cd "$OLDPWD"

# Copy output
cp $LINUX_BUILD"2"/arch/arm/boot/zImage $DEST_DIR
cp $LINUX_BUILD"2"/arch/arm/boot/dts/sun8i-h3-orangepi-one.dtb $DEST_DIR

