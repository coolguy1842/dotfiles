{ lib, cfg, ... }: {
    wayland.windowManager.hyprland.settings.exec-once = [
        "swww-daemon &"
        "playerctld &"
        "nm-applet &"
        "vesktop &"
        "youtube-music &"
        "signal-desktop --use-tray-icon --start-in-tray &"
        "electron-mail &"
        "element-desktop &"
    ] ++ (if cfg.display.ags.enable then [ "ags &" ] else []);

    wayland.windowManager.hyprland.settings.exec = [
        "cycle-wallpaper"
    ];
}
