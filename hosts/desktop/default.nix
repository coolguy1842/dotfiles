{ config, pkgs, lib, inputs, username, ... }: {
    imports = [
        ./config.nix
        ./vm.nix
        ./packages.nix
    ];

    hardware.enableRedistributableFirmware = true;

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
    };

    services = {
        displayManager.sddm = {
            enable = true;
            wayland.enable = true;
        };

        xserver.videoDrivers = [ "amd" ];
    };

    users.defaultUserShell = pkgs.bash;    
    users.users."${username}" = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" "dialout" "input" "plugdev" "libvirtd" "qemu" ];
    };
}
