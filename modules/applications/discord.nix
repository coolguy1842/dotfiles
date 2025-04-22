{ config, lib, pkgs, ... }: {
    options.discord.enable = lib.mkEnableOption "Enable discord";

    config = lib.mkIf config.discord.enable {
        users.users.senoraraton = {
            packages = builtins.attrValues { inherit(pkgs)
                vencord;
            };
        };
    };
}
