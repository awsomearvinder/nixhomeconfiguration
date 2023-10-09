{
  description = "My home configuration.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager.url = "github:nix-community/home-manager/";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    eww-flake.url = "github:elkowar/eww";
    helix-flake.url = "github:helix-editor/helix";
    helix-flake.inputs.nixpkgs.follows = "nixpkgs-unstable";
    agenix.url = "github:ryantm/agenix";
    custom-neovim.url = "github:awsomearvinder/custom-neovim-flake";
    custom-neovim.inputs.nixpkgs.follows = "nixpkgs-unstable";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = {
    home-manager,
    nixpkgs,
    nixpkgs-master,
    nixpkgs-unstable,
    agenix,
    eww-flake,
    helix-flake,
    custom-neovim,
    impermanence,
    ...
  }: let
    system = "x86_64-linux";
    overlays =
      import ./bender/overlays
      ++ [
        (final: prev: {
          custom-neovim = custom-neovim.defaultPackage."x86_64-linux";
          nixpkgs-master = import nixpkgs-master {
            config.allowUnfree = true;
            inherit system;
          };

          eww-wayland = eww-flake.packages.${system}.eww-wayland;

          nixpkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };

          bind = nixpkgs.legacyPackages.${system}.bind.overrideAttrs (old: {
            configureFlags =
              old.configureFlags
              ++ ["--with-dlz-ldap=${nixpkgs.lib.getDev nixpkgs.legacyPackages.${system}.ldb}" "--with-dlz-filesystem" "--with-dlopen"];
            buildInputs = old.buildInputs ++ [(nixpkgs.lib.getDev nixpkgs.legacyPackages.${system}.ldb) (nixpkgs.lib.getDev nixpkgs.legacyPackages.${system}.openldap)];
          });
          helix = helix-flake.packages.${system}.helix;
        })
      ];
  in {
    nixosConfigurations.desktop =
    (nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager
        impermanence.nixosModule
        { config = { nixpkgs.overlays = overlays; }; }
        agenix.nixosModules.age
        ./system/desktop/configuration.nix
      ];
    });

    nixosConfigurations.work_vm =
    (nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager
        impermanence.nixosModule
        { config = { nixpkgs.overlays = overlays; }; }
        agenix.nixosModules.age
        ./system/work_vm/configuration.nix
      ];
    });
  };
}
