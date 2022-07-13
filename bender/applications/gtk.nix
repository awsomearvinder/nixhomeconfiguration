{ config, pkgs, ... }: {
  gtk = {
    enable = true;
    theme.package = pkgs.gruvbox-dark-gtk;
    theme.name = "gruvbox-dark-gtk";
    gtk3.extraCss = "/* Remove rounded corners */
    .window-frame, .window-frame:backdrop {
       box-shadow: 0 0 0 black;
       border-style: none;
       margin: 0;
       border-radius: 0;
    }
      
    .titlebar {
       border-radius: 0;
    }
      
    .window-frame.csd.popup {
        box-shadow: 0 1px 2px rgba(0, 0, 0, 0.2), 0 0 0 1px rgba(0, 0, 0, 0.13);
    }
      
    .header-bar {
        background-image: none;
        background-color: #ededed;
        box-shadow: none;
    }
    GtkLabel.title {
          opacity: 0;
    }
    ";
  };
}
