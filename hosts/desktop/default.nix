{ config, pkgs, lib, inputs, username, ... }: {
    imports = [
        ./config.nix
        ./tandoor.nix
        ./vm.nix
        ./packages.nix
    ];
    
    boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        initrd.kernelModules = [ "amdgpu" ];

        loader = {
            systemd-boot = {
                enable = true;
                memtest86.enable = true;
            };

            efi.canTouchEfiVariables = true;
        };
    };

    networking = {
        networkmanager.enable = true;
        firewall.enable = false;

        nameservers = [ "1.1.1.1" "1.0.0.1" ];
        interfaces.enp15s0 = {
            ipv4.addresses = [{
                address = "192.168.1.4";
                prefixLength = 24;
            }];
            
            useDHCP = false;
        };
        
        defaultGateway = {
            address = "192.168.1.1";
            interface = "enp15s0";
        };
    };

    services = {
        displayManager.sddm = {
            enable = true;
            wayland.enable = true;
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

        xserver.videoDrivers = [ "amd" ];
    };

    users.defaultUserShell = pkgs.bash;    
    users.users."${username}" = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" "dialout" "input" "plugdev" "libvirtd" "qemu" "docker" "podman" "gamemode" ];
    };
}
