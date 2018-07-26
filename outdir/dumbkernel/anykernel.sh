# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=Dumb Kernel
kerversion.string=v0.78
developer.string=dumbDevpr/iykeDROID @ xda-developers
model.string=Moto E4
codename.string=woods
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=Moto E4
device.name2=woods
device.name3=XT1762
'; } # end properties

# shell variables
block=/dev/block/platform/mtk-msdc.0/11230000.msdc0/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chmod 644 $ramdisk/modules/*;
chown -R root:root $ramdisk/*;


# Print message and exit
die() {
  ui_print " "; ui_print "$*";
  exit 1;
}


# Select the correct image to flash
# userRomflavor
os="custom"
os_string="a Custom OS"
#esac;
ui_print " ";
ui_print "You are on $os_string!";
ui_print " </> ";
ui_print "Your Warranty is Void!";
if [ -f /tmp/anykernel/kernels/$os/Image ]; then
  mv /tmp/anykernel/kernels/$os/Image /tmp/anykernel/Image;
else
  die "There is no kernel for your OS in this zip! Aborting...";
fi;


## AnyKernel install
dump_boot;

# begin ramdisk changes

  # sepolicy_debug
  $bin/magiskpolicy --load sepolicy_debug --save sepolicy_debug \
    "allow init rootfs file execute_no_trans" \
    "allow { init modprobe } rootfs system module_load" \
    "allow init { system_file vendor_file vendor_configs_file } file mounton" \
  ;


  # Remove recovery service so that TWRP isn't overwritten
  remove_section init.rc "service flash_recovery" ""

# end ramdisk changes

write_boot;


## end install

