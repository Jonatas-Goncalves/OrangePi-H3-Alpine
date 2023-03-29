# DO NOT EDIT THIS FILE
#
# Please edit /boot/alpineEnv.txt to set supported parameters
#

setenv load_addr "0x45000000"
setenv overlay_error "false"
# default values
setenv verbosity "1"
setenv console "both"
setenv disp_mem_reserves "off"
setenv disp_mode "1920x1080p60"
setenv rootfstype "vfat"
setenv docker_optimizations "on"
setenv bootlogo "false"
setenv devnum "0"
setenv rootdev "/dev/mmcblk${devnum}p1"
setenv earlycon "off"

# Print boot source
itest.b *0x28 == 0x00 && echo "U-boot loaded from SD"
itest.b *0x28 == 0x01 && echo "U-boot loaded from NAND"
itest.b *0x28 == 0x02 && echo "U-boot loaded from eMMC or secondary SD"
itest.b *0x28 == 0x03 && echo "U-boot loaded from SPI"

# get PARTUUID of first partition on SD/eMMC it was loaded from
# mmc 0 is always mapped to device u-boot (2016.09+) was loaded from
if test "${devtype}" = "mmc"; then
	part uuid mmc ${devnum}:1 partuuid;
	setenv devnum ${mmc_bootdev}
	setenv rootdev "/dev/mmcblk${mmc_bootdev}p1"
fi

echo "Boot script loaded from ${devtype}"

if test -e ${devtype} ${devnum} ${prefix}alpineEnv.txt; then
	load ${devtype} ${devnum} ${load_addr} ${prefix}alpineEnv.txt
	env import -t ${load_addr} ${filesize}
fi

if test "${console}" = "display" || test "${console}" = "both"; then setenv consoleargs "console=ttyS0,115200 console=tty1"; fi
if test "${console}" = "serial"; then setenv consoleargs "console=ttyS0,115200"; fi
if test "${earlycon}" = "on"; then setenv consoleargs "earlycon ${consoleargs}"; fi
if test "${bootlogo}" = "true"; then
	setenv consoleargs "splash plymouth.ignore-serial-consoles ${consoleargs}"
else
	setenv consoleargs "splash=verbose ${consoleargs}"
fi

setenv bootargs "root=${rootdev} rootwait rootfstype=${rootfstype} ${consoleargs} hdmi.audio=EDID:0 disp.screen0_output_mode=${disp_mode} consoleblank=0 loglevel=${verbosity} ubootpart=${partuuid} ubootsource=${devtype} usb-storage.quirks=${usbstoragequirks} ${extraargs} ${extraboardargs}"

if test "${disp_mem_reserves}" = "off"; then setenv bootargs "${bootargs} sunxi_ve_mem_reserve=0 sunxi_g2d_mem_reserve=0 sunxi_fb_mem_reserve=16"; fi
if test "${docker_optimizations}" = "on"; then setenv bootargs "${bootargs} cgroup_enable=memory swapaccount=1"; fi

load ${devtype} ${devnum} ${ramdisk_addr_r} ${prefix}initramfs
load ${devtype} ${devnum} ${kernel_addr_r} ${prefix}zImage

if test -e ${devtype} ${devnum} "${prefix}.next"; then
	echo "Found mainline kernel configuration"
	load ${devtype} ${devnum} ${fdt_addr_r} ${prefix}dtbs/${fdtfile}
	fdt addr ${fdt_addr_r}
	fdt resize 65536
	for overlay_file in ${overlays}; do
		if load ${devtype} ${devnum} ${load_addr} ${prefix}dtbs/overlay/${overlay_prefix}-${overlay_file}.dtbo; then
			echo "Applying kernel provided DT overlay ${overlay_prefix}-${overlay_file}.dtbo"
			fdt apply ${load_addr} || setenv overlay_error "true"
		fi
	done
	for overlay_file in ${user_overlays}; do
		if load ${devtype} ${devnum} ${load_addr} ${prefix}overlay-user/${overlay_file}.dtbo; then
			echo "Applying user provided DT overlay ${overlay_file}.dtbo"
			fdt apply ${load_addr} || setenv overlay_error "true"
		fi
	done
	if test "${overlay_error}" = "true"; then
		echo "Error applying DT overlays, restoring original DT"
		load ${devtype} ${devnum} ${fdt_addr_r} ${prefix}dtbs/${fdtfile}
	else
		if load ${devtype} ${devnum} ${load_addr} ${prefix}dtbs/overlay/${overlay_prefix}-fixup.scr; then
			echo "Applying kernel provided DT fixup script (${overlay_prefix}-fixup.scr)"
			source ${load_addr}
		fi
		if test -e ${devtype} ${devnum} ${prefix}fixup.scr; then
			load ${devtype} ${devnum} ${load_addr} ${prefix}fixup.scr
			echo "Applying user provided fixup script (fixup.scr)"
			source ${load_addr}
		fi
	fi
	bootz ${kernel_addr_r} ${ramdisk_addr_r} ${fdt_addr_r}
else
	echo "Found legacy kernel configuration"
	load ${devtype} ${devnum} ${fdt_addr_r} ${prefix}script.bin
	bootz ${kernel_addr_r} ${ramdisk_addr_r}
fi

# Recompile with:
# mkimage -C none -A arm -T script -d /boot/boot.cmd /boot/boot.scr