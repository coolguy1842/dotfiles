{ config, pkgs, lib, inputs, ... }: {
    imports = [
        ../../modules
    ];

    nvidia.enable = true;
    nvidia.prime.enable = true;
    hyprland.enable = true;
    discord.enable = true;
    steam.enable = true;

    users.defaultUserShell = pkgs.bash;
    
    home-manager.backupFileExtension = "backup";
    nix = {
        package = pkgs.nixVersions.stable;
        extraOptions = "experimental-features = nix-command flakes";
    };

    hardware.enableRedistributableFirmware = true;

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.kernelPackages = pkgs.linuxPackages_latest;

    networking.hostName = "coolguy-nix";
    networking.networkmanager.enable = true;

    time.timeZone = "Australia/Brisbane";
    i18n.defaultLocale = "en_AU.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_AU.UTF-8";
        LC_IDENTIFICATION = "en_AU.UTF-8";
        LC_MEASUREMENT = "en_AU.UTF-8";
        LC_MONETARY = "en_AU.UTF-8";
        LC_NAME = "en_AU.UTF-8";
        LC_NUMERIC = "en_AU.UTF-8";
        LC_PAPER = "en_AU.UTF-8";
        LC_TELEPHONE = "en_AU.UTF-8";
        LC_TIME = "en_AU.UTF-8";
    };

    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

    networking.firewall = {
        enable = true;
        allowedTCPPorts = [ 22 ];
        allowedUDPPorts = [ 22 ];
    };

    hardware.bluetooth.enable = true;

    security.rtkit.enable = true;
    services.pulseaudio.enable = false;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
    };

    users.groups.plugdev = {};
    users.users.coolguy = {
        isNormalUser = true;
        description = "coolguy";
        extraGroups = [
            "networkmanager"
            "wheel"
            "dialout"
            "plugdev"
        ];
    };

    fonts.packages = with pkgs; [
        source-code-pro
        font-awesome
        powerline-fonts
        powerline-symbols
    ];

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
        youtube-music
        ente-auth
        plex-desktop
        electron-mail
        element-desktop
        signal-desktop
        baobab
        r2modman
        psmisc
        playerctl
        socat
        wev
        mesa-demos
        inputs.zen-browser.packages."${system}".default
    ];

    nix.optimise.automatic = true;

    nix.gc.automatic = true;
    nix.gc.dates = "daily";
    nix.gc.options = "--delete-older-than 7d";

    services.udev.extraRules = ''
        SUBSYSTEM=="hidraw", KERNEL=="hidraw*", ATTRS{idVendor}=="20a0", ATTRS{idProduct}=="0006", MODE="0660", GROUP="plugdev"
    '';

    system.stateVersion = "24.11";
}
