{ lib, pkgs, cfg, ... }: {
    wayland.windowManager.hyprland.settings.exec-once = (if cfg.display.ags.enable then [ "ags &" ] else []) ++ [
        "${(pkgs.writeShellScriptBin "startApps" (lib.readFile ../../../scripts/startApps.sh))}/bin/startApps"
    ];
    
    wayland.windowManager.hyprland.settings.exec = [
        "cycle-wallpaper"
    ];
}
