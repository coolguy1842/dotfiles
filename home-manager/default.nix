{ inputs, pkgs, ... }: let  
    configDirPath = builtins.path { name = "ags"; path = ../ags; };
in {
    home.stateVersion = "24.11";
    imports = [
        ./git.nix
        ./bash.nix
        ./direnv.nix
        ./theme.nix
        ./kitty.nix
        ./hyprland
        ./ags.nix
    ];
}