{ lib, config, ... }: {
    options.display.hyprland = with lib; {
        enable = mkEnableOption "Enable Hyprland";
        animation = {
            enable = mkEnableOption "Enable Hyprland Animations";
        };

        modifier = mkOption { type = types.str; default = "SUPER"; };

        monitors = mkOption {
            type = types.attrsOf (types.submodule {
                options = {
                    workspaceBind = mkOption { type = types.str; default = "${config.display.hyprland.modifier}"; };
                    workspaces = mkOption { type = types.int; };
                    
                    resolution = mkOption { type = types.str; default = "preferred"; };
                    refreshRate = mkOption { type = types.nullOr types.int; default = null; example = 60; };

                    position = mkOption { type = types.str; default = "auto"; };
                    scaling = mkOption { type = types.float; default = 1.0; };
                };
            });
        };
            
        specialWorkspaces = mkOption {
            type = types.attrsOf (types.submodule {
                options = {
                    modifier = mkOption { type = types.str; default = "${config.display.hyprland.modifier}"; };
                    moveModifier = mkOption { type = types.str; default = "${config.display.hyprland.modifier} SHIFT"; };
                    keybind = mkOption { type = types.str; example = "E"; };
                };
            });
            default = {};
        };

        drmDevices = mkOption { type = lib.types.listOf lib.types.str; default = []; };

        primaryMonitor = mkOption { type = lib.types.str; };
        activeShader = mkOption { type = lib.types.str; default = "vibrance"; };
    };
}