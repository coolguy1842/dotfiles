{ config, pkgs, lib, inputs, username, ... }: {
    imports = [
        ../common.nix
        ./config.nix
    ];

    hardware.enableRedistributableFirmware = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

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

        flatpak = {
            update.auto = {
                enable = true;
                onCalendar = "weekly";
            };
            
            uninstallUnmanaged = true;
        };
    };
    
    users.users."${username}" = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" "dialout" "plugdev" "libvirtd" "qemu" ];
    };

    # TODO: add modules for these
    environment.systemPackages = with pkgs; [
        clang-tools
        networkmanagerapplet
        kitty
        vscode
        smartmontools
        pavucontrol
        fastfetch
        nautilus
        gnome-disk-utility
        cheese
        proton-pass
        ente-auth
        electron-mail
        element-desktop
        signal-desktop
        prismlauncher
        librewolf
        baobab
        r2modman
        mesa-demos
        inputs.zen-browser.packages."${system}".default
    ];
}
