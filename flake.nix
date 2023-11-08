{
  description = "My home configuration.";

  inputs = {
    home-manager.url = "github:nix-community/home-manager/";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    helix-flake.url = "github:helix-editor/helix";
    helix-flake.inputs.nixpkgs.follows = "nixpkgs-unstable";
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

          nixpkgs-unstable = import nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };

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
