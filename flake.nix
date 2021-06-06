{
  description = "My home configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = { home-manager, nixpkgs, ... }: 
  let settings = import ./settings.nix; in{
    nixosConfigurations.nixos = (nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
      	./system/laptop/configuration.nix
        (home-manager.nixosModules.home-manager)
        {
          config = {
            home-manager.users.bender = import ./bender/home.nix;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            nixpkgs.overlays = import ./bender/overlays;
          };
        }
      ] /*++ (if settings.machine == "laptop" then
        [ ./system/laptop/configuration.nix ]
      else
        [ ./configuration.nix ])*/;
    });
  };
}
