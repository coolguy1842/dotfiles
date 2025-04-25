{ lib, ... }: {
    options.media = {
        plex = {
            desktop.enable = lib.mkEnableOption "Enable Plex Desktop";
            media-player.enable = lib.mkEnableOption "Enable Plex Media Player";
            htpc.enable = lib.mkEnableOption "Enable Plex HTPC";
        };

        youtube-music.enable = lib.mkEnableOption "Enable Youtube Music";
    };
}