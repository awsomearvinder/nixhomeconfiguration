{
  description = "My home configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager/";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    custom-neovim.url = "github:awsomearvinder/custom-neovim-flake";
    custom-neovim.inputs.nixpkgs.follows = "nixpkgs-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = {
    self,
    home-manager,
    nixpkgs,
    nixpkgs-master,
    nixpkgs-unstable,
    agenix,
    deploy-rs,
    custom-neovim,
    ...
  }: let
    system = "x86_64-linux";
    overlays = import ./bender/overlays ++ [
      (final: prev: {
        custom-neovim = custom-neovim.defaultPackage."x86_64-linux";
        nixpkgs-master = import nixpkgs-master {
          config.allowUnfree = true;
          inherit system;
        };

        nixpkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
        };

        bind = nixpkgs.legacyPackages.${system}.bind.overrideAttrs (old: {
          configureFlags =
            old.configureFlags
            ++ ["--with-dlz-ldap=${nixpkgs.lib.getDev nixpkgs.legacyPackages.${system}.ldb}" "--with-dlz-filesystem" "--with-dlopen"];
          buildInputs = old.buildInputs ++ [(nixpkgs.lib.getDev nixpkgs.legacyPackages.${system}.ldb) (nixpkgs.lib.getDev nixpkgs.legacyPackages.${system}.openldap)]; });
      })
    ];
    baseModules = system_config: [
      (home-manager.nixosModules.home-manager)
      {
        config = {
          home-manager.users.bender = import ./bender/home.nix system_config;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          nixpkgs.overlays = overlays;
        };
      }
      agenix.nixosModules.age
    ];

    mkSystem = system: config: system_config:
      nixpkgs-unstable.lib.nixosSystem {
        inherit system;
        modules =
          (baseModules config)
          ++ [system_config];
      };

    mkSystemx86_64Linux = mkSystem "x86_64-linux";
  in {

    nixosConfigurations.desktop = let
      config = {gui_supported = true;};
    in (mkSystemx86_64Linux config ./system/desktop/configuration.nix);

    nixosConfigurations.work_vm = let
      config = {gui_supported = true; work_account = true;};
    in (mkSystemx86_64Linux config ./system/work_vm/configuration.nix);

    homeConfigurations.bender = home-manager.lib.homeManagerConfiguration {
      modules = [
        (import ./bender/home.nix {
          gui_supported = true;
          work_account = false;
        })
        {
          home = {
            username = "bender";
            homeDirectory = "/home/bender";
            stateVersion = "20.09";
          };
        }
      ];
      pkgs = import nixpkgs-unstable {
        config.allowUnfree = true;
        inherit overlays;
        system = "x86_64-linux";
      };
    };

    homeConfigurations.benderWork = home-manager.lib.homeManagerConfiguration {
      modules = [
        (import ./bender/home.nix {
          gui_supported = true;
          work_account = true;
        })
        {
          home = {
            username = "bender";
            homeDirectory = "/home/bender";
            stateVersion = "20.09";
          };
        }
      ];
      pkgs = import nixpkgs-unstable {
        config.allowUnfree = true;
        inherit overlays;
        system = "x86_64-linux";
      };
    };

    deploy = let
      mkSystemNode = host: systemConfigName: {
        hostname = host;
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.${systemConfigName};
        };
      };
    in {
      sshUser = "root";
      user = "root";
      magicRollback = false;
      autoRollback = false;
    };

    checks =
      builtins.mapAttrs
      (system: deployLib: deployLib.deployChecks self.deploy)
      deploy-rs.lib;
  };
}

