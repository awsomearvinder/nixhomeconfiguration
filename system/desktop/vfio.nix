{
  config,
  lib,
  ...
}: let
  types = lib.types;
  cfg = config.vfio;
in {
  options.vfio = {
    enable = lib.mkEnableOption "vfio";
    pci-ids = lib.mkOption {
      type = types.listOf types.str;
      example = "ffff:ffff";
    };
    cpu-type = lib.mkOption {
      type = types.enum ["amd" "intel"];
      example = "amd";
    };
  };
  config = lib.mkIf cfg.enable {
    boot.initrd.kernelModules = ["vfio_pci" "vfio" "vfio_iommu_type1"];
    boot.kernelParams = ["${cfg.cpu-type}_iommu=on" "iommu=pt" "vfio-pci.ids=${builtins.concatStringsSep "," cfg.pci-ids}"];
    boot.kernelModules = ["kvm-${cfg.cpu-type}"];
  };
}
