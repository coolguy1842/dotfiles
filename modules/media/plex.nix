{ lib, config, pkgs, ... }: {
    config = lib.mkMerge [
        (lib.mkIf config.media.plex.media-player.enable { environment.systemPackages = with pkgs; [ plex-media-player ]; })
        (lib.mkIf config.media.plex.desktop.enable { environment.systemPackages = with pkgs; [ plex-desktop ]; })
    ];
}