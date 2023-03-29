#!/bin/sh

#Creating environment variables
SRC_DIR=src
BUILD_DIR=build
DEST_DIR=bin
OVERLAY=overlay

UBOOT="ftp.denx.de/pub/u-boot/u-boot-2023.01.tar.bz2"
LINUX="https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.15.93.tar.xz"
ALPINE="https://dl-cdn.alpinelinux.org/alpine/v3.17/releases/armv7/alpine-uboot-3.17.2-armv7.tar.gz"

UBOOT_SRC=$SRC_DIR/$(basename $UBOOT)
LINUX_SRC=$SRC_DIR/$(basename $LINUX)
ALPINE_SRC=$SRC_DIR/$(basename $ALPINE)

UBOOT_BUILD=$BUILD_DIR/uboot
LINUX_BUILD=$BUILD_DIR/linux
ALPINE_BUILD=$BUILD_DIR/alpine

TOOLCHAIN=/opt/linaro-toolchain/bin/
