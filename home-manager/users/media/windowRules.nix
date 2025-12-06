{ ... }: {
    wayland.windowManager.hyprland.settings.windowrule = [
        "workspace 1 silent, initialClass:^(Plex HTPC)$"
        "workspace 2 silent, initialClass:^(firefox)$"
        "workspace 3 silent, initialClass:^([Ss]team)$"
        "workspace 3 silent, initialTitle:^([Ss]team)$"
        "workspace 4 silent, initialClass:^(com.moonlight_stream.Moonlight)$"
        "workspace 5 silent, initialClass:^(chiaki-ng)$"
    ];
}