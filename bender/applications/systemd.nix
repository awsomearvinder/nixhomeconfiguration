{ ... }:
{
  systemd.user.slices = {
    app = {
      Unit = {
        Description = "Slice for all my apps";
      };
      Slice = {
        ManagedOOMSwap = "kill";
        ManagedOOMMemoryPressure = "kill";
        ManagedOOMMemoryPressureLimit = "40%";
      };
    };
  };
}
