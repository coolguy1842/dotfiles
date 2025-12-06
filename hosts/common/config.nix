{ lib, config, username, ... }: {
    networking.hostName = "nixos-${username}";

    hardware.enableRedistributableFirmware = lib.mkDefault true;

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
        LC_ALL = config.input.locale;
    };

    services.xserver = {
        xkb = {
            layout = config.input.keyboardLayout;
            variant = "";
        };
    };

    nix.extraOptions = ''
        download-speed = 1000
    '';

    qt = {
        enable = true;
        platformTheme = "qt5ct";
    };
    
    programs.dconf.enable = true;
}