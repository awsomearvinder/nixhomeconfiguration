{
  description = "My home configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager/";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    deploy-rs.url = "github:serokell/deploy-rs";
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;
    flake-compat-ci.url = "github:hercules-ci/flake-compat-ci";
    hercules-ci.url = "github:hercules-ci/hercules-ci-agent";
  };

  outputs =
    { self
    , home-manager
    , nixpkgs
    , nixpkgs-master
    , nixpkgs-unstable
    , agenix
    , deploy-rs
    , flake-compat-ci
    , hercules-ci
    , ...
    }:
    let
      baseModules = overlays: system_config: [
        (home-manager.nixosModules.home-manager)
        (hercules-ci.nixosModules.multi-agent-service)
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

      mkSystem = system: config: system_config: nixpkgs-unstable.lib.nixosSystem {
        inherit system;
        modules = (baseModules (self._overlay "x86_64-linux") config)
          ++ [ system_config ];
      };

      mkSystemx86_64Linux = mkSystem "x86_64-linux";
    in
    {
      ciNix = flake-compat-ci.lib.recurseIntoFlakeWith {
        flake = self;

        # Optional. Systems for which to perform CI.
        # By default, every system attr in the flake will be built.
        # Example: [ "x86_64-darwin" "aarch64-linux" ];
        systems = [ "x86_64-linux" ];
      };

      _overlay = system: final: prev: {
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
            ++ [ "--with-dlz-ldap=${nixpkgs.lib.getDev nixpkgs.legacyPackages.${system}.ldb}" "--with-dlz-filesystem" "--with-dlopen" ];
          buildInputs = old.buildInputs ++ [ (nixpkgs.lib.getDev nixpkgs.legacyPackages.${system}.ldb) (nixpkgs.lib.getDev nixpkgs.legacyPackages.${system}.openldap) ];
        });

        samba = nixpkgs.legacyPackages.${system}.samba.override { enableLDAP = true; enableDomainController = true; enablePam = true; };
      };

      nixosConfigurations.desktop =
        let config = { gui_supported = true; };
        in (mkSystemx86_64Linux config ./system/desktop/configuration.nix);
      nixosConfigurations.laptop =
        let config = { gui_supported = true; };
        in (mkSystemx86_64Linux config ./system/laptop/configuration.nix);
      nixosConfigurations.work_vm =
        let config = { gui_supported = false; };
        in (mkSystemx86_64Linux config ./system/work_vm/configuration.nix);
      nixosConfigurations.wireguard_server =
        let config = { gui_supported = false; };
        in (mkSystemx86_64Linux config ./system/wireguard_server/configuration.nix);
      nixosConfigurations.hydra_server =
        let config = { gui_supported = false; };
        in (mkSystemx86_64Linux config ./system/hydra_server/configuration.nix);

      homeConfigurations.bender = home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        configuration = import ./bender/home.nix { gui_supported = false; };
        homeDirectory = "/home/bender";
        username = "bender";
        pkgs = import nixpkgs-unstable { overlays = [ (self._overlay "x86_64-linux") ]; system = "x86_64-linux"; };
      };

      deploy =
        let mkSystemNode = host: systemConfigName:
          {
            hostname = host;
            profiles.system = {
              user = "root";
              path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.${systemConfigName};
            };
          }; in
        {
          sshUser = "root";
          user = "root";
          magicRollback = false;
          autoRollback = false;
          nodes.wireguard_server = mkSystemNode "10.100.0.1" "wireguard_server";
          nodes.hydra_server = mkSystemNode "10.100.0.1" "hydra_server";
        };
      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy)
        deploy-rs.lib;
    };
}
