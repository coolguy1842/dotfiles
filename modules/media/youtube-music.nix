{ lib, config, pkgs, ... }: {
    config = lib.mkIf config.media.youtube-music.enable {
        environment.systemPackages = with pkgs; [ youtube-music ];
    };
}