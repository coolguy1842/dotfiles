{ config, inputs, pkgs, ... }: let  
    configDirPath = builtins.path { name = "ags"; path = ../ags; };
    zenPath = "${inputs.zen-browser.packages."${pkgs.system}".default}";
    zenAppPath = [ "zen-beta.desktop" "zen.desktop" "${zenPath}/share/applications/zen-beta.desktop" "${zenPath}/share/applications/zen.desktop" ];
in {
    imports = [
        ./bash.nix
        ./direnv.nix
        ./git.nix
        ./theme.nix
        ./kitty.nix
        ./ags.nix
        ./wallpapers.nix
        ./dunst.nix
        ./hyprland
    ];

    xdg.mimeApps = {
        enable = true;
  
        defaultApplications = {
            "default-web-browser" = zenAppPath;
            "text/html" = zenAppPath;
            "x-scheme-handler/http" = zenAppPath;
            "x-scheme-handler/https" = zenAppPath;
            "x-scheme-handler/about" = zenAppPath;
            "x-scheme-handler/unknown" = zenAppPath;
        };
    };

    home.stateVersion = "24.11";
}