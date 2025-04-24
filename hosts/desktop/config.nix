{ lib, config, pkgs, inputs, ... }: {
    users.defaultUserShell = pkgs.bash;
    
    services = {
        bluetooth.enable = true;
        bluetooth.blueman.enable = true;
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
                HDMI-A-1 = { workspaces = 1; resolution = "1680x1050"; refreshRate = 60; position = "0x30"; workspaceBind = "${config.display.hyprland.modifier} ALT"; workspaceIDOffset = 9; };
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

    networking.hostName = "nixos-desktop";

    time.timeZone = "Australia/Brisbane";
    i18n.defaultLocale = config.input.locale;

    i18n.extraLocaleSettings = {
        LC_ADDRESS = config.input.locale;
        LC_IDENTIFICATION = config.input.locale;
        LC_MEASUREMENT = config.input.locale;
        LC_MONETARY = config.input.locale;
        LC_NAME = config.input.locale;
        LC_NUMERIC = config.input.locale;
        LC_PAPER = config.input.locale;
        LC_TELEPHONE = config.input.locale;
        LC_TIME = config.input.locale;
    };

    services.xserver = {
        videoDrivers = [ "amdgpu" ];
        xkb = {
            layout = config.input.keyboardLayout;
            variant = "";
        };
    };

    system.stateVersion = "24.11";
}
