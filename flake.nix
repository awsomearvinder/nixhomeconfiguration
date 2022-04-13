{
  description = "My home configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager/release-21.11";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    deploy-rs.url = "github:serokell/deploy-rs";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
    flake-compat-ci.url = "github:hercules-ci/flake-compat-ci";
  };

  outputs = { self, home-manager, nixpkgs, nixpkgs-master, nixpkgs-unstable
    , agenix, deploy-rs, flake-compat-ci, ... }:
    let
      baseModules = overlays: system_config: [
        (home-manager.nixosModules.home-manager)
        {
          config = {
            home-manager.users.bender = import ./bender/home.nix system_config;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            nixpkgs.overlays = import ./bender/overlays ++ [ overlays ];
          };
        }
        agenix.nixosModules.age
      ];
    in {
      ciNix = flake-compat-ci.lib.recurseIntoFlakeWith {
        flake = self;

        # Optional. Systems for which to perform CI.
        # By default, every system attr in the flake will be built.
        # Example: [ "x86_64-darwin" "aarch64-linux" ];
        systems = [ "x86_64-linux" ];
      };
      overlay = final: prev: {
        nixpkgs-master = import nixpkgs-master {
          config.allowUnfree = true;
          system = "x86_64-linux";
        };
        nixpkgs-unstable = import nixpkgs-unstable { system = "x86_64-linux"; config.allowUnfree = true; };
        bind = nixpkgs.legacyPackages."x86_64-linux".bind.overrideAttrs (old: {
            configureFlags =
              old.configureFlags ++ ["--with-dlz-ldap=${nixpkgs.lib.getDev nixpkgs.legacyPackages."x86_64-linux".ldb}" "--with-dlz-filesystem" "--with-dlopen"];
            buildInputs = old.buildInputs ++ [(nixpkgs.lib.getDev nixpkgs.legacyPackages."x86_64-linux".ldb) (nixpkgs.lib.getDev nixpkgs.legacyPackages."x86_64-linux".openldap)];
          });

        samba = nixpkgs.legacyPackages."x86_64-linux".samba.override { enableLDAP = true; enableDomainController = true; enablePam = true; };
      };
      nixosConfigurations.desktop = let config = { gui_supported = true; };
      in (nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = (baseModules self.overlay config)
          ++ [ ./system/desktop/configuration.nix ];
      });
      nixosConfigurations.laptop = let config = { gui_supported = true; };
      in (nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = (baseModules self.overlay config)
          ++ [ ./system/laptop/configuration.nix ];
      });
      nixosConfigurations.work_vm = let config = { gui_supported = true; };
      in (nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = (baseModules self.overlay config)
          ++ [ ./system/work_vm/configuration.nix ];
      });
      nixosConfigurations.wireguard_server =
        let config = { gui_supported = false; };
        in (nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = (baseModules self.overlay config)
            ++ [ ./system/wireguard_server/configuration.nix ];
        });
      nixosConfigurations.hydra_server =
        let config = { gui_supported = false; };
        in (nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = (baseModules self.overlay config)
            ++ [ ./system/hydra_server/configuration.nix ];
        });
      nixosConfigurations.nas =
        let config = { gui_supported = false; };
        in (nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = (baseModules self.overlay config)
            ++ [ ./system/nas/configuration.nix ];
        });

      homeConfigurations.bender = home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        configuration = import ./bender/home.nix { gui_supported = false; };
        homeDirectory = "/home/bender";
        username = "bender";
        pkgs = import nixpkgs { overlays = [ self.overlay ]; system = "x86_64-linux"; };
      };

      deploy = {
        sshUser = "root";
        user = "root";
        magicRollback = false;
        autoRollback = false;
        nodes.wireguard_server = {
          hostname = "10.100.0.1";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.wireguard_server;
          };
        };
        nodes.hydra_server = {
          hostname = "10.100.0.3";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.hydra_server;
          };
        };
        nodes.nas = {
          hostname = "192.168.1.153";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos 
              self.nixosConfigurations.nas;
          };
        };
      };
      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
