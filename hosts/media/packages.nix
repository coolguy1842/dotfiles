{ pkgs, ... }: {
    fonts.packages = with pkgs; [
        source-code-pro
        font-awesome
        powerline-fonts
        powerline-symbols
    ];

    environment.systemPackages = with pkgs; [
        git
    ];
}
