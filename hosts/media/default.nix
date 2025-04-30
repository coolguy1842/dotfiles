{ lib, config, inputs, pkgs, username, ... }: {
    imports = [
        ../../modules
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

    boot = {
        loader = {
            timeout = 1;
            
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };

        kernelParams = [ "quiet" "splash" ];
        plymouth.enable = true;
    };

    services = {
        flatpak = {  
            update.auto = {
                enable = true;
                onCalendar = "weekly";
            };
            
            uninstallUnmanaged = true;
        };

        openssh = {
            enable = true;
            ports = [ 22 ];
            
            settings = {
                PasswordAuthentication = true;
                AllowedUsers = null;
                PermitRootLogin = "no";
            };
        };
    };

    programs.bash = {
        loginShellInit = ''
            if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" -eq 1 ]; then
                # give network some time
                sleep 1

                dbus-run-session ${pkgs.cage}/bin/cage -s -- ${pkgs.flatpak}/bin/flatpak run tv.plex.PlexHTPC
            fi
        '';
    };

    networking = {
        networkmanager.enable = true;
        firewall = {
            enable = true;
            
            allowedTCPPorts = [ 22 ];
            allowedUDPPorts = [];
        };
    };

    hardware.graphics.enable = true;
    xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        
        extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
            xdg-desktop-portal-wlr
        ];

        config = {
            common = {
                default = [
                    "gtk"
                    "wlr"
                ];
            };
        };
    };

    services = {
        dbus.enable = true;
        getty.autologinUser = "${username}";
    };

    systemd.network.wait-online.enable = true;

    users.defaultUserShell = pkgs.bash;    
    users.users."${username}" = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" "dialout" ];
    };
}
