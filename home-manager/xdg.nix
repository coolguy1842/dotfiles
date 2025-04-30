{ lib, inputs, cfg, pkgs, ... }: {
    xdg.portal.enable = lib.mkForce false;

    xdg.mimeApps = {
        enable = true;
  
        defaultApplications = with cfg.applications.defaults; {
            "default-web-browser" = web-browser.desktopFile;
            
            "text/html"              = web-browser.desktopFile;
            "x-scheme-handler/http"  = web-browser.desktopFile;
            "x-scheme-handler/https" = web-browser.desktopFile;

            "inode/directory" = file-manager.desktopFile;
        };

        associations.added = with cfg.applications.defaults; {
            "x-scheme-handler/http"         = [ web-browser.desktopFile ];
            "x-scheme-handler/https"        = [ web-browser.desktopFile ];
            "x-scheme-handler/chrome"       = [ web-browser.desktopFile ];
            "text/html"                     = [ web-browser.desktopFile ];
            "application/x-extension-htm"   = [ web-browser.desktopFile ];
            "application/x-extension-html"  = [ web-browser.desktopFile ];
            "application/x-extension-shtml" = [ web-browser.desktopFile ];
            "application/xhtml+xml"         = [ web-browser.desktopFile ];
            "application/x-extension-xhtml" = [ web-browser.desktopFile ];
            "application/x-extension-xht"   = [ web-browser.desktopFile ];

            "inode/directory" = [ file-manager.desktopFile ];
        };
    };
}