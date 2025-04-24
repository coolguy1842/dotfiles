{ cfg, ... }: {
    wayland.windowManager.hyprland.settings.input = {
        kb_layout  = "${cfg.input.keyboardLayout}";
        kb_variant = "";
        kb_model   = "";
        kb_options = "";
        kb_rules   = "";

        accel_profile  = "flat";
        force_no_accel = 1;
        follow_mouse   = 1;
        sensitivity    = cfg.input.sensitivity;

        touchpad = {
            natural_scroll = "no";
        };
    };
}