{
  description = "My home configuration.";

  inputs = {
    home-manager.url = "github:nix-community/home-manager/";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    agenix.url = "github:ryantm/agenix";
    custom-neovim.url = "github:awsomearvinder/custom-neovim-flake";
    custom-neovim.inputs.nixpkgs.follows = "nixpkgs-unstable";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = {
    home-manager,
    nixpkgs-master,
    nixpkgs-unstable,
    agenix,
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

          nixpkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };

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

    nixosConfigurations.laptop =
    (nixpkgs-unstable.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        home-manager.nixosModules.home-manager
        impermanence.nixosModule
        ./system/laptop/configuration.nix
        { config = { nixpkgs.overlays = overlays; }; }
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
