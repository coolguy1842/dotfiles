{ lib, config, ... }: {
    options.services = {
        bluetooth = {
            enable = lib.mkEnableOption "Enable Bluetooth";
            blueman.enable = lib.mkEnableOption "Enable Blueman";
        };

        # dont want to conflict with real option
        sound = {
            pipewire = {
                enable = lib.mkEnableOption "Enable Pipewire";
                rtkit.enable = lib.mkOption { type = lib.types.bool; default = true; description = "Enable RTKit"; example = false; };
                
                alsa = {
                    enable = lib.mkOption { type = lib.types.bool; default = true; description = "Enable Pipewire-Alsa"; example = false; };
                    support32Bit = lib.mkOption { type = lib.types.bool; default = true; description = "Enable x86 Compatibility for Alsa"; example = false; };
                };
                
                pulse.enable = lib.mkOption { type = lib.types.bool; default = true; description = "Enable Pipewire-Pulse"; example = false; };
                jack.enable = lib.mkOption { type = lib.types.bool; default = true; description = "Enable Pipewire-Jack"; example = false; };

                wireplumber.enable = lib.mkOption { type = lib.types.bool; default = true; description = "Enable Wireplumber"; example = false; };
            };
        };
    };
}