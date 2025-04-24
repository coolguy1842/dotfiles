{ lib, config, ... }: {
    options.sober.enable = lib.mkEnableOption "Enable Sober";

    config = lib.mkIf config.games.sober.enable {
        services.flatpak.enable = true;
        services.flatpak.remotes = [ { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; } ];
        services.flatpak.packages = [ "org.vinegarhq.Sober" ];
    };
}