{ inputs, config, pkgs, username, ... }: let 
    plugdevRules = pkgs.writeTextFile {
        name        = "90-plugdev";
        text        = builtins.readFile ../../rules/plugdev.rules;
        destination = "/etc/udev/rules.d/90-plugdev.rules";
    };
in {
    imports = [
        ../../configs
        ../../modules
        ./configHook.nix
        ./config.nix
        ./packages.nix
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
            
            uninstallUnmanaged = false;
        };
    };

    home-manager.backupFileExtension = "backup";
    
    users.groups.plugdev = {};
    services.udev.packages = [ plugdevRules ];

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