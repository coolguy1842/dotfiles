{ lib, config, inputs, pkgs, username, ... }: {
    imports = [
        ../common.nix
        ./config.nix
        ./packages.nix
    ];

    boot = {
        loader = {
            timeout = 1;
            
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };

        kernelParams = [ "quiet" ];
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

        displayManager = {
            sddm = {
                enable = true;
                wayland.enable = true;
            };

            autoLogin.enable = true;
            autoLogin.user = "${username}";
        };
    };

    networking = {
        networkmanager.enable = true;
        firewall = {
            enable = true;
            
            allowedTCPPorts = [ 22 ];
            allowedUDPPorts = [];
        };
    };

    systemd.network.wait-online.enable = true;

    users.defaultUserShell = pkgs.bash;    
    users.users."${username}" = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" "dialout" ];
    };
}
