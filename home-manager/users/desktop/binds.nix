{ cfg, ... }: {
    wayland.windowManager.hyprland.settings.bind = [  "ALT, SPACE, exec, dbus-send --session --type=method_call --dest=com.coolguy1842.Widgets /Widgets com.coolguy1842.Widgets.ToggleQuickLauncher" ];
}