# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  ...
}: {
  imports = [];

  boot.initrd.availableKernelModules = ["sd_mod" "sr_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = [];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F92A-F654";
    fsType = "vfat";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/1b041f23-0907-4cc5-9ce6-090e7598bf62";
    fsType = "btrfs";
    options = ["subvol=nix" "noatime" "compress-force=zstd" "ssd"];
  };

  fileSystems."/etc/nixos" = {
    device = "/dev/disk/by-uuid/1b041f23-0907-4cc5-9ce6-090e7598bf62";
    fsType = "btrfs";
    options = ["subvol=config" "noatime" "compress-force=zstd" "ssd"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/1b041f23-0907-4cc5-9ce6-090e7598bf62";
    fsType = "btrfs";
    options = ["subvol=home" "noatime" "compress-force=zstd" "ssd"];
  };

  fileSystems."/persist" = {
    device = "/dev/disk/by-uuid/1b041f23-0907-4cc5-9ce6-090e7598bf62";
    fsType = "btrfs";
    options = ["subvol=persist" "noatime" "compress-force=zstd" "ssd"];
    neededForBoot = true;
  };

  swapDevices = [];
  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eth0.useDHCP = lib.mkDefault true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  virtualisation.hypervGuest = {
    enable = true;
    videoMode = "1920x1080";
  };
}
