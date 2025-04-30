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

        libsForQt5.qt5ct
        qt6ct
        adwaita-qt
        adwaita-icon-theme
    ];
}