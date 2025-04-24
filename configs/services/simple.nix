{ lib, config, ... }: {
    options.services = {
        bluetooth = {
            enable = lib.mkEnableOption "Enable Bluetooth";
            blueman.enable = lib.mkEnableOption "Enable Blueman";
        };
    };
}