{ config, pkgs, lib, ... }: {
    wayland.windowManager.hyprland = {
        enable = true;

        settings = {
            import ./hyprland/monitors.nix
        }
    };
}