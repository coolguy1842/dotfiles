{ inputs, pkgs, ... }: {
    # TODO: add modules for these
    environment.systemPackages = with pkgs; [
        clang-tools
        networkmanagerapplet
        kitty
        vscode
        smartmontools
        pavucontrol
        fastfetch
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
        gnome-disk-utility
        gnome-text-editor
        kdePackages.dolphin
        inputs.zen-browser.packages."${system}".default
    ];
}