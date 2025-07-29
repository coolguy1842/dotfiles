{ lib, cfg, pkgs, ... }: {
    wayland.windowManager.hyprland.settings.bind = [
        "ALT, SPACE, exec, dbus-send --session --type=method_call --dest=com.coolguy1842.Widgets /Widgets com.coolguy1842.Widgets.ToggleQuickLauncher"
        "${cfg.display.hyprland.modifier}, END, exec, ${(pkgs.writeShellScriptBin "toggleFreeze" (lib.replaceStrings [ "$(jqBin)" ] [ "${pkgs.jq}/bin/jq" ] (lib.readFile ../../../scripts/toggleFreeze.sh)))}/bin/toggleFreeze"
    ];
}