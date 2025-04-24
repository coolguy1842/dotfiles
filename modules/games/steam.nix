{ config, lib, pkgs, ... }: {
    config = lib.mkIf config.games.steam.enable {
        programs.steam = {
            enable = true;
            package = with pkgs; steam.override { extraPkgs = pkgs: [attr]; };
        };

        # horizon fw bugs out with audio from nofiles
        security.pam.loginLimits = [
            { domain = "*"; type = "soft"; item = "nofile"; value = "8192";     }
            { domain = "*"; type = "hard"; item = "nofile"; value = "infinity"; }
        ];
    };
}