{ ... }: {
    home.file.".config/shaders/vibrance.glsl".source = ./shaders/vibrance.glsl;

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

        screen_shader = "~/.config/shaders/vibrance.glsl";
    };
}
