{
  description = "My home configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    settings.url = "path:./settings.nix";
    settings.flake = false;
  };

  outputs = { home-manager, nixpkgs, settings, ... }:
    let
      baseModules = [
        (home-manager.nixosModules.home-manager)
        {
          config = {
            home-manager.users.bender = import ./bender/home.nix;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            nixpkgs.overlays = import ./bender/overlays;
          };
        }
      ];
    in {
      nixosConfigurations.desktop = (nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = baseModules ++ [ ./system/desktop/configuration.nix ];
      });
      nixosConfigurations.laptop = (nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = baseModules ++ [ ./system/laptop/configuration.nix ];
      });
    };
}
