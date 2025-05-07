{ pkgs, ... }: {
    wayland.windowManager.hyprland.settings.workspace = [
        "1, decorate:false, border:false, gapsin:0, gapsout:0, rounding:false, on-created-empty: ${pkgs.flatpak}/bin/flatpak run tv.plex.PlexHTPC"
        "2, decorate:false, border:false, gapsin:0, gapsout:0, rounding:false, on-created-empty: ${pkgs.librewolf}/bin/librewolf"
        "3, decorate:false, border:false, gapsin:0, gapsout:0, rounding:false, on-created-empty: ${pkgs.chiaki}/bin/chiaki"
    ];
}