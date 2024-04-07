{ lib, ... }:
{
  options = {
    machine_name = lib.mkOption { type = lib.types.str; };
  };
}
