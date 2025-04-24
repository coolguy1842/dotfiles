{ config, lib, pkgs, ... }: {
    config = lib.mkIf config.applications.discord.enable {
        environment.systemPackages = with pkgs; [
            discord
            vesktop
            vencord
        ];
    };
}
