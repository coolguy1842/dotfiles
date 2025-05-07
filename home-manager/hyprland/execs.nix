{ lib, cfg, ... }: {
    wayland.windowManager.hyprland.settings.exec-once = [
        "systemctl --user import-environment PATH WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
    ];
}