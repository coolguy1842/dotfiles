{ config, pkgs, lib, ... }: {
    wayland.windowManager.hyprland = {
        enable = true;
    };

    imports = [
        ./hyprland/monitors.nix
        ./hyprland/binds.nix
    ];
}
