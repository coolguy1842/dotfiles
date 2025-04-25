{ lib, config, pkgs, username, ... }: {
    config = lib.mkMerge [
        (lib.mkIf (config.media.plex.media-player.enable || config.media.plex.desktop.enable) {
            environment.systemPackages = with pkgs; [
                (lib.mkIf config.media.plex.media-player.enable plex-media-player)
                (lib.mkIf config.media.plex.desktop.enable plex-desktop)
            ];
        })
        (lib.mkIf (config.media.plex.htpc.enable) {
            services.flatpak.enable = true;
            services.flatpak.remotes = [ { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; } ];
            services.flatpak.packages = [ "tv.plex.PlexHTPC" ];
        })
    ];
}
