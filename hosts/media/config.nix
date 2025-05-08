{ lib, config, pkgs, username, ... }: {
    services.sound.pipewire.enable = true;
    media.plex.htpc.enable = true;

    display = {
        hyprland = {
            enable = true;
            animation.enable = false;

            primaryMonitor = "HDMI-A-1";
            monitors = {
                HDMI-A-1 = {
                    workspaces = 3;
                    resolution = "2560x1440";
                    refreshRate = 100;
                    position = "0x0";

                    vrr = 1;
                    
                    bitdepth = 8;
                    cm = "hdr";
                    sdrbrightness = 1.2;
                    sdrsaturation = 1.0;
                };
            };
        };
    };

    input = {
        keyboardLayout = "us";
        locale = "en_AU.UTF-8";
    };

    applications = {
        defaults = {
            terminal = { program = "kitty"; desktopFile = "kitty.desktop"; };
        };
    };

    services.xserver = {
        xkb = {
            layout = config.input.keyboardLayout;
            variant = "";
        };
    };
    
    system.stateVersion = "24.11";
}
