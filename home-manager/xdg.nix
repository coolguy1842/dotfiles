{ lib, inputs, cfg, pkgs, ... }: {
    xdg.portal.enable = lib.mkForce false;
    xdg.mimeApps = {
        enable = true;
  
        defaultApplications = with cfg.applications.defaults; {
            "default-web-browser" = web-browser.desktopFile;
            
            "text/html" = web-browser.desktopFile;
            "text/xml" = web-browser.desktopFile;
            "application/xml" = web-browser.desktopFile;
            
            "x-scheme-handler/http" = web-browser.desktopFile;
            "x-scheme-handler/https" = web-browser.desktopFile;
            "x-scheme-handler/about" = web-browser.desktopFile;
            "x-scheme-handler/unknown" = web-browser.desktopFile;
        };
    };
}