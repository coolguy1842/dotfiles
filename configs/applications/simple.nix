{ lib, ... }: {
    options.applications = {
        discord.enable = lib.mkEnableOption "Enable Discord";
    };
}