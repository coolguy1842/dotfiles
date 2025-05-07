{ config, pkgs, lib, inputs, username, ... }: {
    imports = [
        ../common.nix
        ./config.nix
        ./vm.nix
        ./packages.nix
    ];

    hardware.enableRedistributableFirmware = true;

    boot = {
        kernelPackages = pkgs.linuxPackages_latest;

        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };
    };

    networking = {
        networkmanager.enable = true;
        
        firewall = {
            enable = true;
            
            allowedTCPPorts = [];
            allowedUDPPorts = [];
        };
    };

    services = {
        displayManager.sddm = {
            enable = true;
            wayland.enable = true;
        };
    };

    users.defaultUserShell = pkgs.bash;    
    users.users."${username}" = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" "dialout" "input" "plugdev" "libvirtd" "qemu" ];
    };
}
