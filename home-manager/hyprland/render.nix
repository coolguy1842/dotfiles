{ lib, moduleConfig, ... }: {
    wayland.windowManager.hyprland.settings.env = (if moduleConfig.hyprland.drmDevices != null then [ "AQ_DRM_DEVICES,${moduleConfig.hyprland.drmDevices}" ] else []);
    wayland.windowManager.hyprland.settings.render = {
        explicit_sync = 1;
        explicit_sync_kms = 1;
        direct_scanout = false;
    };
}
