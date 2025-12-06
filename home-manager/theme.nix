{ pkgs, ... }: {
    home.pointerCursor = {
        gtk.enable = true;
        package = pkgs.vanilla-dmz;
        name = "Vanilla-DMZ";
        size = 16;

        hyprcursor.enable = true;
    };
    
    qt = {
        enable = true;
        platformTheme.name = "qt6ct";
    };

    gtk = {
        enable = true;

        theme = {
            name = "Adwaita-dark";
            package = pkgs.gnome-themes-extra;
        };
      
        iconTheme = {
            name = "Adwaita";
            package = pkgs.adwaita-icon-theme;
        };
    };

    home.sessionVariables.GTK_THEME = "Adwaita-dark";

    dconf = {
        enable = true;
        settings = {
            "org/gnome/desktop/interface".color-scheme = "prefer-dark";
        };
    };
}