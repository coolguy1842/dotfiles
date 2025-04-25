{ lib, config, pkgs, ... }: {
    users.defaultUserShell = pkgs.bash;

    services = {
        sound.pipewire.enable = true;
    };

    # will remove hyprland & ags later, keeping until its setup
    display = {
        ags.enable = true;
        hyprland = {
            enable = true;
            animation.enable = true;

            primaryMonitor = "HDMI-A-1";
            monitors = {
                HDMI-A-1 = { workspaces = 9; };
            };
        };
    };
    
    media.plex.htpc.enable = true;

    input = {
        keyboardLayout = "us";
        locale = "en_AU.UTF-8";
    };

    networking.hostName = "nixos-media";

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
        xkb = {
            layout = config.input.keyboardLayout;
            variant = "";
        };
    };

    system.stateVersion = "24.11";
}