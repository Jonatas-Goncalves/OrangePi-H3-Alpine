#!/bin/sh

source ./env.sh
echo
echo
# Add this section to ask which OrangePi H3 card the user is using
echo "Which OrangePi H3 board are you using?"
echo
echo "1. Orange Pi Zero"
echo "2. Orange Pi 2"
echo "3. Orange Pi Lite"
echo "4. Orange Pi One"
echo "5. Orange Pi PC"
echo "6. Orange Pi Plus"
echo "7. Orange Pi Plus2e"
echo "8. Orange Pi ZeroPlus2"
echo
read -p "Enter the number corresponding to your OrangePi H3 or H2 board: " ORANGEPI

# Create a variable for the selected board
case $ORANGEPI in
	1)
		BOARD="zero"
		MODEL="sun8i-h2-plus-orangepi-"
		;;
	2)
		BOARD="2"
		MODEL="sun8i-h3-orangepi-"
		;;
	3)
		BOARD="lite"
		MODEL="sun8i-h3-orangepi-"
		;;
	4)
		BOARD="one"
		MODEL="sun8i-h3-orangepi-"
		;;
	5)
		BOARD="pc"
		MODEL="sun8i-h3-orangepi-"
		;;
	6)
		BOARD="plus"
		MODEL="sun8i-h3-orangepi-"
		;;
	7)
		BOARD="plus2e"
		MODEL="sun8i-h3-orangepi-"
		;;
	8)
		BOARD="zeroplus2"
		MODEL="sun8i-h3-orangepi-"
		;;
	*)
		echo "Placa OrangePi H3 inválida!"
		exit 1
		;;
esac

# Work around variable errors in this script
ORANGEPI="orangepi_"
DEFCONFIG="_defconfig"
DTB_EXT=".dtb"
export DTB_FILE="$MODEL$BOARD$DTB_EXT"
export DEFCONFIG_CONF="$ORANGEPI$BOARD$DEFCONFIG"

# Update board model in boot.cmd file
sed -i "s/sun8i-h3-orangepi-.*.dtb/sun8i-h3-orangepi-${BOARD}.dtb/" boot_script/boot.cmd


mkdir -p $SRC_DIR
mkdir -p $BUILD_DIR
mkdir -p $DEST_DIR
mkdir -p $DEST_DIR/$OVERLAY

while getopts "c" opt; do
	case "$opt" in
		c)
			clean=1
			;;
	esac
done

./get_sources.sh

if ! [ -n "$(ls -A $BUILD_DIR)" ]; then
    ./init_build.sh
fi

./build_uboot.sh 
./build_linux.sh $DTB_FILE $DEST_DIR
./build_overlay.sh
./build_boot_script.sh
./build_initramfs.sh
./build_modloop.sh

echo
echo
echo
echo
# Add a question to run format_sd.sh script to Format SD Card and Install Alpine
read -p "Want to format SD card and write u-Boot, Kernel and Alpine? (y/n)" FORMAT
if [ "$FORMAT" = "y" ] || [ "$FORMAT" = "n" ]; then
  ./format_sd.sh
fi