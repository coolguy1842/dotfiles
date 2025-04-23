{ config, ... }: {
    wayland.windowManager.hyprland.settings.monitor = [
        "${config.mainMonitor.name}, 1920x1080@165, 1680x0, 1"
        "${config.secondMonitor.name}, 1680x1050@60, 0x30, 1"
    ];
}
