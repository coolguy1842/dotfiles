{ config, pkgs, lib, inputs, username, ... }: {
    imports = [
        ../common.nix
        ./config.nix
        ./packages.nix
    ];

    hardware.enableRedistributableFirmware = true;

    boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        blacklistedKernelModules = [ "nouveau" ];

        loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
        };
    };

    networking = {
        networkmanager.enable = true;
        
        firewall = {
            enable = true;
            allowedTCPPorts = [ 22 ];
            allowedUDPPorts = [ 22 ];
        };
    };

    security.rtkit.enable = true;
    services = {
        displayManager.sddm = {
            enable = true;
            wayland.enable = true;
        };
    };

    users.defaultUserShell = pkgs.bash;    
    users.users."${username}" = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" "dialout" "plugdev" "libvirtd" "qemu" ];
    };
}
