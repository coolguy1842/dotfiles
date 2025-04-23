{ ... }: {
    wayland.windowManager.hyprland.settings.decoration = {
        rounding = 8;

        blur = {
            enabled = true;
            
            size = 5;
            passes = 1;
            
            new_optimizations = "on";
        };

        shadow = {
            enabled = true;

            range = 4;
            render_power = 3;
            
            color = "rgba(1a1a1aee)";
        };
    };
}
