#!/bin/sh
# Custom build script


KERNEL_DIR=$PWD
ZIMAGE=$KERNEL_DIR/outdir/arch/arm/boot/zImage-dtb
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
green='\033[0;92m'
red='\033[0;31m'
purple='\033[0;95m'
white='\033[0;97m'
nocol='\033[0m'

#make kernel compiling dir...
mkdir -p outdir


#exports ::
#toolchain , custom build_user , custom build_host , arch
export ARCH=arm
export ARCH_MTK_PLATFORM=mt6735
#export CROSS_COMPILE=~/arm-eabi-4.9/bin/arm-eabi-
export CROSS_COMPILE=$PWD/arm-gnu-7.x/bin/arm-gnu-linux-androideabi-
#export CROSS_COMPILE=$PWD/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-
#export CROSS_COMPILE=/home/dumbdevpr/Moto_E4/toolchain/linaro_arm-eabi-6.3/bin/arm-eabi-
export KBUILD_BUILD_USER="dumbDevpr"
export KBUILD_BUILD_HOST="OSL-Dell"


compile_kernel ()
{
 echo
 echo
 
echo "$blue·▄▄▄▄  ▄• ▄▌• ▌ ▄ ·. ▄▄▄▄·    
██▪ ██ █▪██▌·██ ▐███▪▐█ ▀█▪   
▐█· ▐█▌█▌▐█▌▐█ ▌▐▌▐█·▐█▀▀█▄ "  
echo "$yellow██. ██ ▐█▄█▌██ ██▌▐█▌██▄▪▐█   
▀▀▀▀▀•  ▀▀▀ ▀▀  █▪▀▀▀·▀▀▀▀  "  
echo "$yellow▄ •▄ ▄▄▄ .▄▄▄   ▐ ▄ ▄▄▄ .▄▄▌"  
echo "$purple█▌▄▌▪▀▄.▀·▀▄ █·•█▌▐█▀▄.▀·██•  
▐▀▀▄·▐▀▀▪▄▐▀▀▄ ▐█▐▐▌▐▀▀▪▄██▪  
▐█.█▌▐█▄▄▌▐█•█▌██▐█▌▐█▄▄▌▐█▌▐▌
·▀  ▀ ▀▀▀ .▀  ▀▀▀ █▪ ▀▀▀ .▀▀▀ "

echo
echo
echo "$blue***********************************************"
echo "          Compiling Dumb™ Kernel...          "
echo "***********************************************$nocol"
echo ""
#woods defconfig
make -C $PWD O=outdir ARCH=arm woods_defconfig
#
make -j4 -C $PWD O=outdir ARCH=arm
echo "$yellow Copying to outdir/dumbkernel $nocol"
cp outdir/arch/arm/boot/zImage-dtb outdir/dumbkernel/kernels/custom/Image

if ! [ -f $ZIMAGE ];
then
echo "$red Kernel Compilation failed! Fix the errors! $nocol"
exit 1
fi
}

zip_zak ()
{
echo
  echo
echo "$cyan█ ▄▄  ██   ▄█▄    █  █▀ ▄█    ▄     ▄▀  
█   █ █ █  █▀ ▀▄  █▄█   ██     █  ▄▀    
█▀▀▀  █▄▄█ █   ▀  █▀▄   ██ ██   █ █ ▀▄  
█     █  █ █▄  ▄▀ █  █  ▐█ █ █  █ █   █ 
 █       █ ▀███▀    █    ▐ █  █ █  ███  
  ▀     █          ▀       █   ██       
       ▀  "
echo  "$cyan***********************************************"
echo "          Packing Dumb™ Kernel...          "
echo  "***********************************************$nocol"
echo ""
echo  "$yellow Putting Dumb™ Kernel in Recovery Flashable Zip $nocol"
#using lazy kernel flasher
cd outdir
cd dumbkernel
    if 
    [ -f outdir/dumbkernel/out_done ] 
    then
    rm -rf out_done
    else
    make
    mkdir -p out_done
    cp Dumb.Kernel_woods*zip* out_done
    cd ../../
    sleep 0.6;
    echo ""
    echo ""
    echo "" "Done Making Recovery Flashable Zip"
    echo ""
    echo ""
    echo "" "Locate Dumb™ Kernel in the following path : "
    echo "" "outdir/dumbkernel/out_done"
    echo ""
echo  "$green▄   █ ▄▄  █    ████▄ ██   ██▄   ▄█    ▄     ▄▀  
   █  █   █ █    █   █ █ █  █  █  ██     █  ▄▀    
█   █ █▀▀▀  █    █   █ █▄▄█ █   █ ██ ██   █ █ ▀▄  
█   █ █     ███▄ ▀████ █  █ █  █  ▐█ █ █  █ █   █ 
█▄ ▄█  █        ▀         █ ███▀   ▐ █  █ █  ███  
 ▀▀▀    ▀                █           █   ██       
                        ▀ "                         
    echo
    echo  "$blue***********************************************"
    echo "      Uploading Dumb™ Kernel to Web[https://transfer.sh/]"
    echo  "***********************************************$nocol"
    echo ""
    echo " l.o.a.d.i.n.g..."
    sleep 0.4;
    echo "   please wait..."
    sleep 0.1;
    echo ""
    curl --upload-file outdir/dumbkernel/out_done/Dumb.Kernel_woods*.zip https://transfer.sh/Dumb.Kernel_woods-v0.78_$BUILD_START.zip
    echo ""
    echo ""
    echo " uPLOADING dONE !!!"
    echo ""
    echo ""
    BUILD_END=$(date +"%s")
    DIFF=$(($BUILD_END - $BUILD_START))
    echo "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$n"
    sleep 15.0;
    echo ""
    echo ""
echo "$green·▄▄▄▄      ▐ ▄▄▄▄ .
██▪ █▪    •█▌▐▀▄.▀·
▐█· ▐█▄█▀▄▐█▐▐▐▀▀▪▄
██. █▐█▌.▐██▐█▐█▄▄▌
▀▀▀▀▀•▀█▄▀▀▀ █▪▀▀▀ "
    echo ""
    echo ""
    fi
}


close_me ()
{
clear
 echo
 echo
echo "$green▄▄▄▄·  ▄· ▄▌▄▄▄ .
▐█ ▀█▪▐█▪██▌▀▄.▀·
▐█▀▀█▄▐█▌▐█▪▐▀▀▪▄ "
echo "$yellow██▄▪▐█ ▐█▀·.▐█▄▄▌
·▀▀▀▀   ▀ •  ▀▀▀ "
echo
 echo
 echo
 echo "$blueTalent Is Nothing WIthout Ethics!!!"
 echo
 sleep 2.0;
 clear
exit
}

case $1 in
clean)
#make ARCH=arm -j16 clean mrproper
rm -rf include/linux/autoconf.h
;;
*)
compile_kernel
zip_zak
close_me
;;
esac
