
{ config, lib, pkgs, nixbeta, unstable, nixmaster, inputs, ... }:

{
  system = {
    modulesTree = lib.mkForce [(
      # (pkgs.aggregateModules
      (nixbeta.aggregateModules
        ( config.boot.extraModulePackages ++ [ config.boot.kernelPackages.kernel ])
      ).overrideAttrs {
        # earlier items in the list above override the contents of later items
        ignoreCollisions = true;
      }
    )]; # Allows loading out-of-tree modules over the top of mainline modules
  };

  boot = {
    # kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = nixbeta.linuxPackages_latest;
    kernelModules = [ "tcp_bbr" ];

    kernel = {
      sysctl."net.ipv4.tcp_congestion_control" = "bbr";
      sysctl."net.ipv6.tcp_congestion_control" = "bbr";
      sysctl."net.core.default_qdisc" = "fq";

    # Increase TCP window sizes for high-bandwidth WAN connections, assuming
    # 10 GBit/s Internet over 200ms latency as worst case.
    #
    # Choice of value:
    #     BPP         = 10000 MBit/s / 8 Bit/Byte * 0.2 s = 250 MB
    #     Buffer size = BPP * 4 (for BBR)                 = 1 GB
    # Explanation:
    # * According to http://ce.sc.edu/cyberinfra/workshops/Material/NTP/Lab%208.pdf
    #   and other sources, "Linux assumes that half of the send/receive TCP buffers
    #   are used for internal structures", so the "administrator must configure
    #   the buffer size equals to twice" (2x) the BPP.
    # * The article's section 1.3 explains that with moderate to high packet loss
    #   while using BBR congestion control, the factor to choose is 4x.
    #
    # Note that the `tcp` options override the `core` options unless `SO_RCVBUF`
    # is set manually, see:
    # * https://stackoverflow.com/questions/31546835/tcp-receiving-window-size-higher-than-net-core-rmem-max
    # * https://bugzilla.kernel.org/show_bug.cgi?id=209327
    # There is an unanswered question in there about what happens if the `core`
    # option is larger than the `tcp` option; to avoid uncertainty, we set them
    # equally.
      sysctl."net.core.wmem_max" = 1073741824; # 1 GiB
      sysctl."net.core.rmem_max" = 1073741824; # 1 GiB
      sysctl."net.ipv4.tcp_rmem" = "4096 87380 1073741824"; # 1 GiB max
      sysctl."net.ipv6.tcp_rmem" = "4096 87380 1073741824"; # 1 GiB max
      sysctl."net.ipv4.tcp_wmem" = "4096 87380 1073741824"; # 1 GiB max
      sysctl."net.ipv6.tcp_wmem" = "4096 87380 1073741824"; # 1 GiB max
    };
  };

}

