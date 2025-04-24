{ lib, moduleConfig, ... }: let
    shaderPath = ".config/shaders";
in {
    home.file."${shaderPath}" = {
        source = ./shaders;
        recursive = true;
    };

    wayland.windowManager.hyprland.settings.decoration = {
        screen_shader = "~/${shaderPath}/${moduleConfig.hyprland.activeShader}.glsl";
    };
}