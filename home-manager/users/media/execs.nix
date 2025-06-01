{ pkgs, ... }: {
    wayland.windowManager.hyprland.settings.exec-once = [
        "${pkgs.flatpak}/bin/flatpak run tv.plex.PlexHTPC &"
        "${pkgs.librewolf}/bin/librewolf &"
        "${pkgs.flatpak}/bin/flatpak run com.valvesoftware.SteamLink &"
        "${pkgs.chiaki-ng}/bin/chiaki &"
        "${pkgs.moonlight-qt}/bin/moonlight &"

        "${pkgs.ydotool}/bin/ydotoold &"
    ];
}
