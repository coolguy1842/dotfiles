{ pkgs, ... }: {
    wayland.windowManager.hyprland.settings.workspace = [
        "1, decorate:false, border:false, gapsin:0, gapsout:0, rounding:false, on-created-empty: ${pkgs.flatpak}/bin/flatpak run tv.plex.PlexHTPC"
        "2, decorate:false, border:false, gapsin:0, gapsout:0, rounding:false, on-created-empty: ${pkgs.firefox}/bin/firefox"
        "3, decorate:false, border:false, gapsin:0, gapsout:0, rounding:false, on-created-empty: ${pkgs.steam}/bin/steam"
        "4, decorate:false, border:false, gapsin:0, gapsout:0, rounding:false, on-created-empty: ${pkgs.moonlight-qt}/bin/moonlight"
        "5, decorate:false, border:false, gapsin:0, gapsout:0, rounding:false, on-created-empty: ${pkgs.chiaki-ng}/bin/chiaki"
    ];
}