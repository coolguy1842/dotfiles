{ lib, ... }: {
    options.games = {
        steam.enable = lib.mkEnableOption "Enable Steam";
        sober.enable = lib.mkEnableOption "Enable Sober";
    };
}