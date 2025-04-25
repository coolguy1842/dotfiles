{ pkgs, ... }: {
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