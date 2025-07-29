{ config, pkgs, lib, inputs, username, ... }: {
    imports = [
        ./config.nix
        ./vm.nix
        ./packages.nix
    ];
    
    # temp workaround as linux-firmware for amd gpu gives edid error
    hardware.firmware = [ 
        (pkgs.linux-firmware.overrideAttrs (old: rec {
            version = "20250509";
            src = pkgs.fetchzip {
                url = "https://cdn.kernel.org/pub/linux/kernel/firmware/linux-firmware-${version}.tar.xz";
                hash = "sha256-0FrhgJQyCeRCa3s0vu8UOoN0ZgVCahTQsSH0o6G6hhY=";
            };
        }))
    ];

    boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        initrd.kernelModules = [ "amdgpu" ];

        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };
    };

    networking = {
        networkmanager.enable = true;
        
        firewall = {
            enable = false;
            
            allowedTCPPorts = [];
            allowedUDPPorts = [];
        };

        nameservers = [ "1.1.1.1" "1.0.0.1" ];
        interfaces.enp12s0 = {
            ipv4.addresses = [{
                address = "192.168.1.4";
                prefixLength = 24;
            }];
            
            useDHCP = false;
        };
        
        defaultGateway = {
            address = "192.168.1.1";
            interface = "enp12s0";
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
        extraGroups = [ "networkmanager" "wheel" "dialout" "input" "plugdev" "libvirtd" "qemu" ];
    };
}
