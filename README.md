# OrangePi H3 - Alpine Linux
Build scripts for install Alpine Linux on OrangePi H3 Boards

**This project aims to facilitate the installation of Alpine Linux and Uboot on OrangePi One**

Alpine Linux is an extremely lightweight Linux distribution, functionally immutable and with low resource consumption.


***What do you need?***


**Device Tree Compiler:**

    Opensuse: sudo zypper install dtc
    Debian/Ubuntu: sudo apt-get install device-tree-compiler
    Fedora/CentOS: sudo dnf install dtc
    Arch Linux: sudo pacman -S device-tree-compiler
    Snap: sudo snap install device-tree-compiler

**LIBMPC**
*some systems need this package installed to compile without erros*
*Install only if you get erros with mpc.h related*

    Opensuse: sudo zypper install mpc-devel
    Ubuntu: sudo apt-get install libmpc-dev
    Fedora/CentOS: sudo dnf install libmpc-dev
    Arch Linux: sudo pacman -S libmpc-dev

**Linaro Toolchain:**  
*You can use your build native release:*

    Opensuse: sudo zypper install cross-arm-binutils
    Debian/Ubuntu: sudo apt-get install gcc-arm-linux-gnueabihf
    Fedora/CentOS: sudo dnf install binutils-arm-linux-gnu
    Arch Linux: sudo pacman -S arm-none-eabi-binutils
    
**Or**

**Get tarball Linaro Release: https://releases.linaro.org/components/toolchain/binaries/7.4-2019.02/arm-linux-gnueabihf/**

    wget https://releases.linaro.org/components/toolchain/binaries/7.4-2019.02/arm-linux-gnueabihf/gcc-linaro-7.4.1-2019.02-x86_64_arm-linux-gnueabihf.tar.xz -P /tmp/linaro-toolchain.tar.xz
    sudo mkdir /opt/linaro-toolchain-7.4
    sudo tar -xf /tmp/linaro-toochain.tar.xz -C /opt/linaro-toolchain-7.4/ --strip-components=1
    export PATH=/opt/linaro-toolchain-7.4/bin:$PATH


**Configurations:**

    set env.sh >> TOOLCHAIN= to match your toolchain instalation, as default is seted as tarball on /opt/linaro-toolchain

    set build_uboot.sh, build_linux.sh and build_linux2.sh >> export CROSS_COMPILE= to match your toolchain instalation, as default is seted as "arm-linux-gnueabihf-", change as you need.



***I don't have all the boards to test, but I believe it works on all of the list due to similar hardware, test and open an issue with your feedback.***


**All credits for this project go to:**
https://github.com/Roysten
