{ lib, config, pkgs, ... }: {
    config = lib.mkIf config.services.sound.pipewire.enable{
        security.rtkit.enable = config.services.sound.pipewire.rtkit.enable;
        services.pipewire = with config.services.sound; {
            enable = true;
            
            alsa.enable = pipewire.alsa.enable;
            alsa.support32Bit = pipewire.alsa.support32Bit;
            pulse.enable = pipewire.pulse.enable;
            jack.enable = pipewire.jack.enable;
        };
    };
}