{ inputs, config, pkgs, username, ... }: {
    imports = [
        ./commonConfigHook.nix
        ./commonConfigs.nix
        ./commonPackages.nix
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
        flatpak = {  
            update.auto = {
                enable = true;
                onCalendar = "weekly";
            };
            
            uninstallUnmanaged = true;
        };
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
        SUBSYSTEM=="hidraw", KERNEL=="hidraw*", MODE="0660", GROUP="plugdev"
        SUBSYSTEM=="input", KERNEL=="event*", MODE="0660", GROUP="plugdev"
    '';

    security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
            if(
                subject.user == "${username}"
                && (
                    action.id.indexOf("org.freedesktop.NetworkManager.") == 0 ||
                    action.id.indexOf("org.freedesktop.ModemManager") == 0
                )
            ) {
                return polkit.Result.YES;
            }
        });

        polkit.addRule(function(action, subject) {
        if(
            subject.isInGroup("users")
            && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
            )
            ) {
                return polkit.Result.YES;
            }
        });
    '';
}