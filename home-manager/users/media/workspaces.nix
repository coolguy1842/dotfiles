{ pkgs, ... }: {
    wayland.windowManager.hyprland.settings.workspace = [
        "1, decorate:false, border:false, gapsin:0, gapsout:0, rounding:false"
        "2, decorate:false, border:false, gapsin:0, gapsout:0, rounding:false"
        "3, decorate:false, border:false, gapsin:0, gapsout:0, rounding:false"
    ];
}