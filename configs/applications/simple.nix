{ lib, pkgs, ... }: let 
    applicationType = with lib.types; submodule (_: {
        options = {
            program = lib.mkOption { type = str; };
            desktopFile = lib.mkOption { type = str; };
        };
    });
in {
    options.applications = with lib; {
        defaults = {
            web-browser  = mkOption { type = applicationType; example = { program = "firefox"; desktopFile = "firefox.desktop"; }; };
            file-manager = mkOption { type = applicationType; example = { program = "dolphin"; desktopFile = "dolphin.desktop"; }; };
            terminal     = mkOption { type = applicationType; example = { program = "kitty";   desktopFile = "kitty.desktop"; }; };
        };

        discord.enable = mkEnableOption "Enable Discord";
        blender.enable = mkEnableOption "Enable Blender";
    };
}