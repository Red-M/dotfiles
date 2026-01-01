
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  # nixpkgs.overlays = [(final: prev: {
  #   mesa = unstable.mesa;
  # })];

  nixpkgs.config.rocmSupport = true;

  hardware = {
    amdgpu = {
      initrd.enable = true;
      # amdvlk = {
      #   enable = true;
      #   support32Bit.enable = true;
      # };
    };
    # graphics = {
    #   extraPackages = with pkgs; [
    #     amdvlk
    #   ];
    #   extraPackages32 = with pkgs; [
    #     driversi686Linux.amdvlk
    #   ];
    # };
  };

  boot = {
    kernelModules = with config.boot.kernelPackages; [
      "i2c-dev"
      "i2c-piix4"
      "jc42"
    ]; # fans, etc

    # initrd.availableKernelModules = [ "vfio-pci" ];
    # initrd.preDeviceCommands = ''
    #   DEVS="0000:0e:00.1"
    #   for DEV in $DEVS; do
    #     echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
    #   done
    #   modprobe -i vfio-pci
    # '';
    kernelParams = [ "amd_iommu=on" ];
  };

  environment.systemPackages = with pkgs; [
    radeontop
  ];
}

