{
  description = "My home configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = {self, home-manager, nixpkgs, nixpkgs-master, nixpkgs-unstable, agenix, deploy-rs, ... }:
    let
      baseModules = overlays: system_config: [
        (home-manager.nixosModules.home-manager)
        {
          config = {
            home-manager.users.bender = import ./bender/home.nix system_config;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            nixpkgs.overlays = import ./bender/overlays ++ [overlays] ;
          };
        }
        agenix.nixosModules.age
      ];
    in {
      overlay = final: prev: { 
        nixpkgs-master = import nixpkgs-master {config.allowUnfree = true; system = "x86_64-linux";}; 
        nixpkgs-unstable = nixpkgs-unstable.legacyPackages."x86_64-linux"; 
      };
      nixosConfigurations.desktop = let config = { gui_supported = true; }; in (nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = (baseModules self.overlay config) ++ [ ./system/desktop/configuration.nix ];
      });
      nixosConfigurations.laptop = let config = { gui_supported = true; }; in (nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = (baseModules self.overlay config) ++ [ ./system/laptop/configuration.nix ];
      });
      nixosConfigurations.work_vm = let config = {gui_supported = true;}; in (nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = (baseModules self.overlay config) ++ [ ./system/work_vm/configuration.nix ];
      });
      nixosConfigurations.wireguard_server = let config = {gui_supported = false; }; in (nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = (baseModules self.overlay config) ++ [ ./system/wireguard_server/configuration.nix ];
      });
      nixosConfigurations.hydra_server = let config = {gui_supported = false; }; in (nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = (baseModules self.overlay config) ++ [ ./system/hydra_server/configuration.nix ];
      });
      deploy = {
        sshUser = "root";
        user = "root";
        magicRollback = false;
        autoRollback = false;
        nodes.wireguard_server = {
          hostname = "10.100.0.1";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.wireguard_server;
          };
        };
        nodes.hydra_server = {
          hostname = "192.168.1.14";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.hydra_server;
          };
        };
      };
      checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
