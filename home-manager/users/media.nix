{ pkgs, ... }: {
    imports = [
        ../default.nix
    ];

    programs.bash = {
        bashrcExtra = ''
            if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
                dbus-run-session ${pkgs.cage}/bin/cage -s -- ${pkgs.flatpak}/bin/flatpak run tv.plex.PlexHTPC
            fi
        '';
    };
}