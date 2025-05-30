{ config, pkgs, lib, ... }: {
    imports = [
        ./dependencies.nix
        ./envs.nix
        ./monitors.nix
        ./workspaces.nix
        ./windowRules.nix
        ./layerRules.nix
        ./execs.nix
        ./input.nix
        ./general.nix
        ./decoration.nix
        ./animations.nix
        ./dwindle.nix
        ./render.nix
        ./shaders.nix
        ./binds.nix
    ];

    config = {
        wayland.windowManager.hyprland.enable = true;
    };
}
