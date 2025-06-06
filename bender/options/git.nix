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
      enable_sapling = lib.mkOption {
        default = false;
        description = ''
          Whether to install sapling.
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
    home.packages = lib.mkMerge [
      (lib.mkIf cfg.enable_git [pkgs.git-branchless])
      (lib.mkIf cfg.enable_sapling [pkgs.sapling])
    ];

    programs.git = lib.mkIf cfg.enable_git {
      enable = true;
      userName = cfg.name;
      userEmail = cfg.email;
      difftastic.enable = true;
      difftastic.background = "dark";
      extraConfig =
        {
          # "remote \"origin\"" = {
          #   fetch = "+refs/pull/*/head:refs/remotes/origin/pr/*";
          # };
          pull.ff = "only";
          gpg.program = "${pkgs.gnupg}/bin/gpg";
          rerere.enabled = true;
        }
        // (if (cfg ? signing ? gpg_key) then {
          user.signingkey = cfg.signing.gpg_key;
          commit.gpgSign = true;
        } else {});
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
        aliases = {
          "msync" = [
            "rebase"
            "-r"
            "all:fork_point(mutable_heads() | trunk())..mutable_heads()"
            "-d"
            "trunk()"
          ];
        };
        revset-aliases = {
          "mutable_heads()" = "visible_heads() & mutable()";
        };
      };
    };

    xdg.configFile."sapling/sapling.conf" = lib.mkIf cfg.enable_sapling {
      source =
        (pkgs.formats.ini {}).generate "sapling.conf" {
          ui = {
            username = "${cfg.name} <${cfg.email}>";
            editor = "hx";
          };
        }
        // (
          if (cfg ? signing ? gpg_key)
          then {gpg.key = cfg.signing.gpg_key;}
          else {}
        );
    };
  };
}
