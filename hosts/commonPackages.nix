{ pkgs, ... }: {
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