{ ... }: {
    wayland.windowManager.hyprland.settings.windowrule = [
        "suppressevent maximize, class:.*"
        "workspace name:windows silent, initialClass:^(looking-glass-client)$"
        "fullscreen, initialClass:^(looking-glass-client)$"
        "workspace special:discord silent, initialClass:^(discord)|(vesktop)$"
        "workspace special:music silent, initialClass:^(com.github.th_ch.youtube_music)$"
        "workspace special:electronmail silent, initialClass:^(electron-mail)$"
        "float, class:steam, title:^(Friends List)$"
    ];
}