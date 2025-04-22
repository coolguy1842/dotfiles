{ ... }: {
    home.stateVersion = "24.11";
    imports = [
        ./git.nix
        ./kitty.nix
        ./hyprland.nix
    ];
}