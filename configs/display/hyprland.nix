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
                    persistentWorkspaces = mkOption { type = types.bool; default = false; };
                    
                    resolution = mkOption { type = types.str; default = "preferred"; };
                    refreshRate = mkOption { type = types.nullOr types.int; default = null; example = 60; };

                    position = mkOption { type = types.str; default = "auto"; };
                    scaling = mkOption { type = types.float; default = 1.0; };
                    transform = mkOption { type = types.enum [ 0 1 2 3 4 5 6 7 ]; default = 0; };

                    vrr = mkOption { type = types.enum [ 0 1 2 3 ]; example = "0(off), 1(on), 2(fullscreen), 3(fullscreen with video or game attributes)"; default = 0; };

                    bitdepth = mkOption { type = types.int; default = 8; };
                    cm = mkOption { type = types.enum [ "auto" "srgb" "wide" "edid" "hdr" "hdredid" ]; default = "auto"; };

                    sdrbrightness = mkOption { type = types.float; default = 1.0; };
                    sdrsaturation = mkOption { type = types.float; default = 1.0; };
                };
            });

            default = { "" = { workspaces = 0; }; };
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