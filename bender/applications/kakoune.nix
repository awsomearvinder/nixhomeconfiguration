{ config, pkgs, ... }: {
  home.packages = with pkgs; [
    bat
    fzf
  ];
  xdg.configFile."kak-lsp/kak-lsp.toml".source = "${config.dots}/kak-lsp.toml";
  programs.kakoune = {
    enable = true;
    plugins = [
      pkgs.kakounePlugins.kak-lsp
    ];
    config = {
      colorScheme = "gruvbox";
      tabStop = 4;
      autoInfo = [ "command" "onkey" ];
      scrollOff = {
        lines = 1;
      };
      ui = {
        enableMouse = true;
        assistant = "none";
      };
      showMatching = true;

    };
    extraConfig = ''

      hook global WinSetOption filetype=rust %{
        lsp-enable-window
        lsp-auto-signature-help-enable
        hook window -group semantic-tokens BufReload .* lsp-semantic-tokens
        hook window -group semantic-tokens NormalIdle .* lsp-semantic-tokens
        hook window -group semantic-tokens InsertIdle .* lsp-semantic-tokens
        hook -once -always window WinSetOption filetype=.* %{
          remove-hooks window semantic-tokens
        }
      }
      eval %sh{kak-lsp --kakoune -s $kak_session}
      lsp-enable
   '';
  };

}
