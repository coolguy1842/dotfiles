{ lib, ... }: {
    options.media = {
        plex.desktop.enable = lib.mkEnableOption "Enable Plex Desktop";
        plex.media-player.enable = lib.mkEnableOption "Enable Plex Media Player";

        youtube-music.enable = lib.mkEnableOption "Enable Youtube Music";
    };
}