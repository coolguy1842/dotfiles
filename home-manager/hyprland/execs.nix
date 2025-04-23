{ ... }: {
    wayland.windowManager.hyprland.settings.exec-once = [
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
}
