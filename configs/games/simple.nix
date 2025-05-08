{ lib, ... }: {
    options.games = {
        steam.enable = lib.mkEnableOption "Enable Steam";
        steam.remote-play.enable = lib.mkEnableOption "Enable Steam Remote Play";
        sober.enable = lib.mkEnableOption "Enable Sober";
    };
}