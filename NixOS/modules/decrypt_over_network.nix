
{ config, lib, pkgs, nixalt, unstable, outoftree, inputs, ... }:

{
  boot = {
    kernelParams = [ "ip=dhcp" ];
    initrd = {
      availableKernelModules = [ "r8169" ];
      network = {
        enable = true;
        flushBeforeStage2 = true;
        ssh = {
          enable = true;
          port = 2222;
          hostKeys = [ # ssh-keygen -t ed25519 -N "" -f /etc/ssh/initrd_ssh_host_ed25519_key && ssh-keygen -t rsa -N "" -f /etc/ssh/initrd_ssh_host_rsa_key
            "/etc/ssh/initrd_ssh_host_rsa_key"
            "/etc/ssh/initrd_ssh_host_ed25519_key"
          ];
          shell = "/bin/cryptsetup-askpass";
        };
      };
    };
  };
}

