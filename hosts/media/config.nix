{ lib, config, pkgs, username, ... }: {
    users.defaultUserShell = pkgs.bash;

    services.sound.pipewire.enable = true;
    media.plex.htpc.enable = true;

    input = {
        keyboardLayout = "us";
        locale = "en_AU.UTF-8";
    };

    networking.hostName = "nixos-${username}";

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
