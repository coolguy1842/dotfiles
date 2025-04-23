{ pkgs, ... }: {
    # home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ"; 
    home.pointerCursor = {
        gtk.enable = true;
        package = pkgs.vanilla-dmz;
        name = "Vanilla-DMZ";
        size = 16;

        hyprcursor.enable = true;
    };

    home.packages = with pkgs; [
        adwaita-qt
        adwaita-icon-theme
    ];

    qt.enable = true;
    qt.style.name = "adwaita-dark";
    qt.platformTheme.name = "adwaita-dark";

    gtk.enable = true;
    gtk.theme.name = "Adwaita-dark";
    gtk.theme.package = pkgs.gnome-themes-extra;

    home.sessionVariables.QT_QPA_PLATFORMTHEME = "adwaita-dark";
    home.sessionVariables.GTK_THEME = "Adwaita-dark";

    dconf.enable = true;
    dconf.settings = {
        "org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
        };
    };
}