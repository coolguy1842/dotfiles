{ inputs, pkgs, ... }: let  
    configDirPath = builtins.path { name = "ags"; path = ../ags; };
in {
    home.stateVersion = "24.11";
    imports = [
        ./bash.nix
        ./direnv.nix
        ./git.nix
        ./theme.nix
        ./kitty.nix
        ./ags.nix
        ./wallpapers.nix
        ./hyprland
    ];
}