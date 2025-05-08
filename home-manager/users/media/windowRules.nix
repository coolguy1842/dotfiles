{ ... }: {
    wayland.windowManager.hyprland.settings.windowrule = [
        "workspace 1 silent, initialClass:^(Plex HTPC)$"
        "workspace 2 silent, initialClass:^(librewolf)$"
        "workspace 3 silent, initialClass:^(com.valvesoftware.steamlink)$"
        "workspace 4 silent, initialClass:^(chiaki)$"
    ];
}