{ lib, config, inputs, pkgs, username, ... }: {
    imports = [
        ../common.nix
        ./config.nix
        ./packages.nix
    ];

    boot = {
        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;

        };

        kernelParams = [ "quiet" "splash" ];
        plymouth.enable = true;
    };

    services.openssh = {
        enable = true;
        ports = [ 22 ];
        
        settings = {
            PasswordAuthentication = true;
            AllowedUsers = null;
            PermitRootLogin = "no";
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

    users.defaultUserShell = pkgs.bash;    
    users.users."${username}" = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" "dialout" ];
    };
}
