
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  hardware = {
    amdgpu.initrd.enable = true;
  };

  boot = {
    initrd.availableKernelModules = [ "vfio-pci" ];
    initrd.preDeviceCommands = ''
      DEVS="0000:0e:00.1"
      for DEV in $DEVS; do
        echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
      done
      modprobe -i vfio-pci
    '';
    kernelParams = [ "amd_iommu=on" ];
  };
}

