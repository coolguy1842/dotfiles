{ ... }: {
    wayland.windowManager.hyprland.settings.exec-once = [
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "load-portals"
        "ags &"
        "swww-daemon &"
        "playerctld &"
        "nm-applet &"
        "vesktop &"
        "youtube-music &"
        "signal-desktop --use-tray-icon --start-in-tray &"
        "electron-mail &"
        "element-desktop &"
    ];

    wayland.windowManager.hyprland.settings.exec = [
        "cycle-wallpaper"
    ];
}
