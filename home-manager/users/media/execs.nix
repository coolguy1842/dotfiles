{ pkgs, ... }: {
    wayland.windowManager.hyprland.settings.exec-once = [
        "${pkgs.flatpak}/bin/flatpak run tv.plex.PlexHTPC &"
        "${pkgs.librewolf}/bin/librewolf &"
        "${pkgs.flatpak}/bin/flatpak run com.valvesoftware.SteamLink &"
        "${pkgs.chiaki}/bin/chiaki &"

        "${pkgs.ydotool}/bin/ydotoold &"
    ];
}
