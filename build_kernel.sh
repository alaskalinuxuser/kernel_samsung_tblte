#!/bin/bash

###################################################################
###################################################################
# Colorize and add text parameters
red=$(tput setaf 1) # red
grn=$(tput setaf 2) # green
cya=$(tput setaf 6) # cyan
txtbld=$(tput bold) # Bold
bldred=${txtbld}$(tput setaf 1) # red
bldgrn=${txtbld}$(tput setaf 2) # green
bldblu=${txtbld}$(tput setaf 4) # blue
bldcya=${txtbld}$(tput setaf 6) # cyan
txtrst=$(tput sgr0) # Reset
###################################################################
###################################################################
# set Variables 
ARCH="arm"
SUBARCH="arm"
DEVICE="tbltexx"
TOOLCHAIN="/mnt/HDD/Toolchains/uber/UBERTC-arm-eabi-4.9/bin/arm-eabi-"
TOOLCHAIN_DIR="/mnt/HDD/Toolchains"
KERN_CONFIG="kernel_defconfig"
VARIANT_DEFCONFIG="kernel_defconfig"
BUILD_CORES="8"
LOCAL_DIR=""
KERNEL_NAME=""
BUILD_USER="xNNism"
BUILD_HOST="Octacore"
KERN_STRING=""
EXPERIMENTAL_USE_JAVA8="" # leave empty if not needed
###################################################################
###################################################################

echo "${bldgrn}[CONFIGURE] Setting variables...${txtrst}"
echo -e "Build User: ${RED}${SOURCEDIR}${RST}"
echo -e "Directory that contains the ROM source: ${RED}${SOURCEDIR}${RST}"
#
#  Java 8
if [[ -f "$EXPERIMENTAL_USE_JAVA8" ]]; then
export EXPERIMENTAL_USE_JAVA8=true
else
   export EXPERIMENTAL_USE_JAVA8=false
fi
#
export ARCH="$ARCH"
export SUBARCH="$SUBARCH"
export CROSS_COMPILE="$TOOLCHAIN"
export KBUILD_BUILD_USER="$BUILD_USER"
export KBUILD_BUILD_HOST="$BUILD_HOST"
export KERN_CONFIG="$KERN_CONFIG"
export KERN_STRING="$KERN_STRING"
export KERN_AUTHOR="$BUILD_HOST"
export BUILD_CORES="$BUILD_CORES"

###################################################################

cd $(pwd)/$KERNEL_NAME
###################################################################
###################################################################
echo "${bldgrn}[CONFIGURE] Cleaning...${txtrst}"
echo '##########################################'

make clean
###################################################################
###################################################################
echo "${bldgrn}[CONFIGURE] Setting Kernel Configuration ${txtrst}"
echo '#################################################'

make "$KERN_CONFIG"
###################################################################
###################################################################
echo "${bldgrn}[CONFIGURE] Starting Build..${txtrst}"
echo '##############################################'

if [[ -f "$VARIANT_DEFCONFIG" ]]; then
make VARIANT_DEFCONFIG="$VARIANT_DEFCONFIG" -j"$BUILD_CORES"
else
   make "$KERN_CONFIG" -j"$BUILD_CORES"
fi
###################################################################
###################################################################


# If the above compilation was successful, let's notate it
if [[ `ls $(pwd)/"$KERNEL_NAME"/arch/arm/boot/zImage 2>/dev/null | wc -l` != "0" ]]; then
   BUILD_RESULT_STRING="BUILD SUCCESSFUL"
echo "${bldgrn}[DONE] Compilation complete.${txtrst}"
else
echo "${bldgrn}[DONE]...FAILED :(${txtrst}"


###################################################################
###################################################################
# CONFIG_DEBUG_SECTION_MISMATCH=y
# CONFIG_NO_ERROR_ON_MISMATCH=y
# patch -p1 < 
# #./build.py --device d855cm -m -k  -ns -g arm
#
###################################################################
###################################################################
