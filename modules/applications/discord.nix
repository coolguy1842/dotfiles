{ config, lib, pkgs, ... }: {
    options.discord.enable = lib.mkEnableOption "Enable Discord";

    config = lib.mkIf config.discord.enable {
        users.users.coolguy.packages = with pkgs; [
            discord
            vesktop
            vencord
        ];
    };
}
