{ lib, config, ... }: {
    options.hyprland = {
        modifier = with lib; mkOption { type = types.str; default = "SUPER"; };

        monitors = with lib; mkOption {
            type = types.attrsOf (types.submodule {
                options = {
                    workspaceBind = mkOption { type = types.str; default = "${config.hyprland.modifier}"; };
                    workspaces = mkOption { type = types.int; };
                    workspaceOffset = mkOption { type = types.int; default = 0; };

                    resolution = mkOption { type = types.str; default = "preferred"; };
                    refreshRate = mkOption { type = types.nullOr types.int; example = 60; };

                    position = mkOption { type = types.str; default = "auto"; };
                    scaling = mkOption { type = types.float; default = 1.0; };
                };
            });
        };
            
        specialWorkspaces = with lib; mkOption {
            type = types.attrsOf (types.submodule {
                options = {
                    modifier = mkOption { type = types.str; default = "${config.hyprland.modifier}"; };
                    moveModifier = mkOption { type = types.str; default = "${config.hyprland.modifier} SHIFT"; };
                    keybind = mkOption { type = types.str; example = "E"; };
                };
            });
            default = {};
        };

        drmDevices = with lib; mkOption { type = lib.types.nullOr lib.types.str; };
        mainMonitor = with lib; mkOption { type = lib.types.str; };
        activeShader = with lib; mkOption { type = lib.types.str; default = "vibrance"; };
    };
}