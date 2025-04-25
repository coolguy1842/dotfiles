{ lib, inputs, pkgs, ... }: let
    zenPath = "${inputs.zen-browser.packages."${pkgs.system}".default}";
    zenAppPath = [ "zen-beta.desktop" "zen.desktop" "${zenPath}/share/applications/zen-beta.desktop" "${zenPath}/share/applications/zen.desktop" ];
in {
    xdg.portal.enable = lib.mkForce false;
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
}