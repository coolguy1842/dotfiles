{ config, lib, pkgs, ... }: {
    options.steam.enable = lib.mkEnableOption "Enable Steam";

    config = lib.mkIf config.steam.enable {
        programs.steam = {
            enable = true;
            package = with pkgs; steam.override { extraPkgs = pkgs: [attr]; };
        };
    };
}