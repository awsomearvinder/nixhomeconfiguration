{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.custom.version_control;
in {
  options = {
    custom.version_control = {
      enable_git = lib.mkOption {
        default = false;
        description = ''
          Whether to install git.
        '';
      };
      signing = {
        gpg_key = lib.mkOption {
          description = ''
            GPG key to sign changes with.
          '';
        };
      };
      email = lib.mkOption {
        description = ''
          version control email for changes.
        '';
      };
      name = lib.mkOption {
        description = ''
          version control name for changes.
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable_git {
    home.packages = [
      pkgs.git-branchless
    ];

    programs.git = {
      enable = true;
      userName = cfg.name;
      userEmail = cfg.email;
      difftastic.enable = true;
      difftastic.background = "dark";
      extraConfig =
        {
          pull.ff = "only";
          gpg.program = "${pkgs.gnupg}/bin/gpg";
          rerere.enabled = true;
        }
        // (lib.mkIf (cfg ? signing ? gpg_key) {
          user.signingkey = cfg.signing.gpg_key;
          commit.gpgSign = true;
        });
    };
    programs.lazygit = {
      enable = true;
      settings = {
        git = {
          merging = {
            args = "--no-ff";
          };
        };
      };
    };
  };
}
