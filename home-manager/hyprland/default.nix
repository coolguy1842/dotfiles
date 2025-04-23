{ config, pkgs, lib, ... }: {
    options.mainMonitor = {
        name = lib.mkOption { type = lib.types.str; };
        workspaces = lib.mkOption { type = lib.types.int; };
    };

    options.secondMonitor = {
        name = lib.mkOption { type = lib.types.str; };
        workspaces = lib.mkOption { type = lib.types.int; };
    };

    options.activeShader = lib.mkOption { type = lib.types.str; default = "vibrance"; };

    imports = [
        ./monitors.nix
        ./workspaces.nix
        ./windowRules.nix
        ./layerRules.nix
        ./execs.nix
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

        mainMonitor.name = "DP-1";
        mainMonitor.workspaces = 9;

        secondMonitor.name = "HDMI-A-1";
        secondMonitor.workspaces = 1;

        home.packages = with pkgs; [
            wl-clipboard
            clipman
            hyprpicker
            hyprshade
        ];
    };
}
