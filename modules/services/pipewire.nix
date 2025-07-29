{ lib, config, pkgs, ... }: {
    config = with config.services.sound; lib.mkIf pipewire.enable {
        security.rtkit.enable = pipewire.rtkit.enable;
        services.pipewire = {
            enable = true;
            
            alsa.enable = pipewire.alsa.enable;
            alsa.support32Bit = pipewire.alsa.support32Bit;
            pulse.enable = pipewire.pulse.enable;
            jack.enable = pipewire.jack.enable;
        };
    };
}