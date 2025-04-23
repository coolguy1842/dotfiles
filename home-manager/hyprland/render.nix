{ ... }: {
    wayland.windowManager.hyprland.settings.env = [
        "AQ_DRM_DEVICES,/dev/dri/card1"
    ];

    wayland.windowManager.hyprland.settings.render = {
        explicit_sync = 1;
        explicit_sync_kms = 1;
        direct_scanout = false;
    };
}
