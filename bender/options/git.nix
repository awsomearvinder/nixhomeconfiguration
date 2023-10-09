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
      enable_jujutsu = lib.mkOption {
        default = false;
        description = ''
          Whether to install jujutsu.
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
  config = {
    home.packages = lib.mkIf cfg.enable_git [
      pkgs.git-branchless
    ];

    programs.git = lib.mkIf cfg.enable_git {
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
    programs.lazygit = lib.mkIf cfg.enable_git {
      enable = true;
      settings = {
        git = {
          merging = {
            args = "--no-ff";
          };
        };
      };
    };

    programs.jujutsu = lib.mkIf cfg.enable_jujutsu {
      enable = true;
      settings = {
        user = {inherit (cfg) name email;};
      };
    };
  };
}
