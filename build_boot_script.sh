#!/bin/sh

source ./env.sh

mkimage -C none -A arm -T script -d boot_script/boot.cmd $DEST_DIR/boot.scr 
cp boot_script/alpineEnv.txt $DEST_DIR
