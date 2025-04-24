{ lib, pkgs, ... }: {
    options.applications = with lib; {
        defaults = {
            web-browser = mkOption { type = types.package; example = pkgs.firefox; };
            file-browser = mkOption { type = types.package; example = pkgs.nautilus; };
            terminal = mkOption { type = types.package; example = pkgs.kitty; };
        };

        discord.enable = mkEnableOption "Enable Discord";
        blender.enable = mkEnableOption "Enable Blender";
    };
}