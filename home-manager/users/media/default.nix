{ pkgs, ... }: {
    imports = [
        ../../default.nix
        ./workspaces.nix
        ./windowRules.nix
        ./execs.nix
        ./binds.nix
    ];

    wayland.windowManager.hyprland.settings = {
        cursor.inactive_timeout = 2;
        misc.disable_hyprland_logo = true;
    };
}
