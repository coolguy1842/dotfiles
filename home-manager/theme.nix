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
        platformTheme.name = "qt5ct";
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

    dconf = {
        enable = true;
        settings = {
            "org/gnome/desktop/interface".color-scheme = "prefer-dark";
        };
    };
}