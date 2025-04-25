{ lib, config, pkgs, inputs, ... }: {
    users.defaultUserShell = pkgs.bash;
    
    services = {
        bluetooth.enable = true;
        bluetooth.blueman.enable = true;
        
        sound.pipewire.enable = true;

        libvirt.enable = true;
        waveeffect.enable = true;
    };

    display = {
        nvidia.enable = true;
        nvidia.prime.enable = true;
        nvidia.cuda.enable = true;

        ags.enable = true;
        hyprland = {
            enable = true;
            animation.enable = true;

            drmDevices = [ "pci-0000:11:00.0-card" ];

            primaryMonitor = "DP-1";
            monitors = {
                DP-1     = { workspaces = 9; resolution = "1920x1080"; refreshRate = 165; position = "1680x0"; };
                HDMI-A-1 = { workspaces = 1; resolution = "1680x1050"; refreshRate = 60;  position = "0x30"; workspaceBind = "${config.display.hyprland.modifier} ALT"; };
            };

            specialWorkspaces = {
                discord.keybind = "D";
                music.keybind = "S";
                email.keybind = "E";
            };
        };
    };

    applications = {
        defaults = {
            web-browser = inputs.zen-browser.packages."${pkgs.system}".default;
            file-browser = pkgs.nautilus;
            terminal = pkgs.kitty;
        };
        
        discord.enable = true;
        blender.enable = true;
    };

    media = {
        plex.media-player.enable = true;
        plex.desktop.enable = true;
        youtube-music.enable = true;
    };
    
    games = {
        steam.enable = true;
        sober.enable = true;
    };

    "3dprinting" = {
        orca-slicer.enable = true;
    };

    input = {
        sensitivity = -0.52;
        
        keyboardLayout = "us";
        locale = "en_AU.UTF-8";
    };

    system.stateVersion = "24.11";
}
