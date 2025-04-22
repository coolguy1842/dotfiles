{ ... }: {
    wayland.windowManager.hyprland.settings.$mod = "SUPER";
    wayland.windowManager.hyprland.settings.bind = [
        "$mod, W, exec, firefox"
        "$mod, T, exec, kitty"
        "$mod, Q, killactive"
        "$mod SHIFT, BACKSPACE, exit"
    ];
} 
