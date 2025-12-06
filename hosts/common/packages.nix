{ pkgs, ... }: {
    fonts.packages = with pkgs; [
        source-code-pro
        font-awesome
        powerline-fonts
        powerline-symbols
    ];

    environment.systemPackages = with pkgs; [
        git
        wget
        htop
        lshw
        psmisc
        pciutils
        usbutils

        qt6Packages.qt6ct
        adwaita-qt
        adwaita-icon-theme
    ];
}