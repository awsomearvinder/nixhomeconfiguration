{ lib, ...}: {
  options = {
    machine_name = lib.mkOption { type = lib.types.str; };
    wireguard_ip_and_mask = lib.mkOption { type = lib.types.str; };
  };
}
