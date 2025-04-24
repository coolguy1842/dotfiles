{ inputs, config, pkgs, ... }: {
    imports = [
        ./commonConfigHook.nix
    ];

    nix = {
        package = pkgs.nixVersions.stable;
        extraOptions = "experimental-features = nix-command flakes";
        
        settings.auto-optimise-store = true;

        gc = {
            automatic = true;
            dates = "daily";
            options = "--delete-older-than 2d";
        };
    };

    services = {
        gvfs.enable = true;
    };

    home-manager.backupFileExtension = "backup";
    fonts.packages = with pkgs; [
        source-code-pro
        font-awesome
        powerline-fonts
        powerline-symbols
    ];

    users.groups.plugdev = {};
    services.udev.extraRules = ''
        SUBSYSTEM=="hidraw", KERNEL=="hidraw*", ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="0006", MODE="0660", GROUP="plugdev"
    '';
}