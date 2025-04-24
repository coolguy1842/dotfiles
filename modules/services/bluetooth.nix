{ lib, config, pkgs, ... }: {
    config = lib.mkIf config.services.bluetooth.enable {
        hardware.bluetooth = {
            enable = true; 
            powerOnBoot = true; 

            settings = {
                General = {
                    Experimental = true;
                };
            };
        };

        services.blueman.enable = config.services.bluetooth.blueman.enable;
    };
}