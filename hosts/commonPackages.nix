{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        git
        wget
        htop
        lshw
        psmisc
        pciutils
    ];
}