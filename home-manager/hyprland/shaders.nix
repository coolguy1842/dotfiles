{ lib, cfg, ... }: let
    shaderPath = ".config/hypr/shaders";
in {
    home.file."${shaderPath}" = {
        source = ./shaders;
        recursive = true;
    };

    wayland.windowManager.hyprland.settings.decoration = {
        screen_shader = "~/${shaderPath}/${cfg.display.hyprland.activeShader}.glsl";
    };
}