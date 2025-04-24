{ lib, config, cfg, inputs, pkgs, ... }: {
    imports = [
        ./xdg.nix
        ./bash.nix
        ./direnv.nix
        ./git.nix
        ./theme.nix
        ./kitty.nix
        ./wallpapers.nix
        ./dunst.nix
    ]
    ++ (if cfg.display.ags.enable then [ ./ags.nix ] else [])
    ++ (if cfg.display.hyprland.enable then [ ./hyprland ] else []);

    home.stateVersion = "24.11";
}