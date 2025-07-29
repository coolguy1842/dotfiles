{ lib, config, inputs, pkgs, username, ... }: {
    imports = [
        ./config.nix
    ];

    boot = {
        loader = {
            timeout = 1;
            
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };

        kernelPackages = pkgs.linuxPackages_latest;
        kernelParams = [ "quiet" ];
        plymouth.enable = true;
    };

    services = {
        flatpak = {  
            update.auto = {
                enable = true;
                onCalendar = "weekly";
            };
            
            uninstallUnmanaged = false;
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

    environment.systemPackages = with pkgs; [
        firefox
    ];

    systemd.network.wait-online.enable = true;
    boot.kernelModules = [ "uinput" ];

    users.defaultUserShell = pkgs.bash;    
    users.users."${username}" = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" "dialout" "plugdev" "input" ];
    };
}
