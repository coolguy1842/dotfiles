{ config, pkgs, lib, ... }: let
    shaderPath = ".config/shaders";
in {
    home.file."${shaderPath}" = {
        source = ./shaders;
        recursive = true;
    };

    wayland.windowManager.hyprland.settings.decoration = {
        screen_shader = "~/${shaderPath}/${config.activeShader}.glsl";
    };
}