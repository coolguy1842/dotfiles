{ config, pkgs, lib, inputs, ... }: let username = "coolguy"; in {
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
        pulseaudio.enable = false;
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            jack.enable = true;
        };

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
        extraGroups = [ "networkmanager" "wheel" "dialout" "plugdev" ];
    };

    # TODO: add modules for these
    environment.systemPackages = with pkgs; [
        clang-tools
        git
        wget
        bash
        python3
        openssl
        networkmanagerapplet
        pciutils
        kitty
        vscode
        smartmontools
        wofi
        pavucontrol
        fastfetch
        nautilus
        gnome-disk-utility
        wayfreeze
        htop
        lshw
        cheese
        youtube-music
        proton-pass
        ente-auth
        plex-media-player
        electron-mail
        element-desktop
        signal-desktop
        prismlauncher
        librewolf
        baobab
        r2modman
        psmisc
        playerctl
        socat
        wev
        mesa-demos
        inputs.zen-browser.packages."${system}".default
    ];

    security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
            if(
                subject.user == "${username}"
                && (
                    action.id.indexOf("org.freedesktop.NetworkManager.") == 0 ||
                    action.id.indexOf("org.freedesktop.ModemManager") == 0
                )
            ) {
                return polkit.Result.YES;
            }
        });

        polkit.addRule(function(action, subject) {
        if(
            subject.isInGroup("users")
            && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
            )
            ) {
                return polkit.Result.YES;
            }
        });
    '';

}
