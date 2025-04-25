{ lib, config, pkgs, ... }: {
    users.defaultUserShell = pkgs.bash;

    services.sound.pipewire.enable = true;
    media.plex.htpc.enable = true;

    input = {
        keyboardLayout = "us";
        locale = "en_AU.UTF-8";
    };

    networking.hostName = "nixos-media";
    system.stateVersion = "24.11";
}
