{ inputs, pkgs, ... }: {
    # TODO: add modules for these
    environment.systemPackages = with pkgs; [
        clang-tools
        networkmanagerapplet
        kitty
        gimp
        vscode.fhs
        smartmontools
        pavucontrol
        fastfetch
        cheese
        proton-pass
        ente-auth
        electron-mail
        element-desktop
        signal-desktop
        gamescope
        prismlauncher
        heroic
        librewolf
        baobab
        r2modman
        mesa-demos
        gnome-disk-utility
        gnome-text-editor
        kdePackages.ark
        kdePackages.dolphin
        inputs.zen-browser.packages."${system}".default
    ];
}