{ lib, config, pkgs, ... }: {
    config = lib.mkIf config.display.hyprland.enable {
        programs.hyprland = {
            enable = true;
            xwayland.enable = true;
        };

        xdg.portal = {
            enable = true;
            xdgOpenUsePortal = true;
            
            extraPortals = with pkgs; [
                xdg-desktop-portal-gtk
                xdg-desktop-portal-wlr
                xdg-desktop-portal-hyprland
            ];

            wlr.enable = true;
        };

        environment.systemPackages = with pkgs; [
            libnotify
            hyprland-protocols
            polkit
            polkit_gnome
            grim
            slurp
            
            (writeShellScriptBin "load-portals" ''
                killall xdg-desktop-portal-hyprland
                killall xdg-desktop-portal-wlr
                killall xdg-desktop-portal-gtk
                killall xdg-desktop-portal

                killall .xdg-desktop-portal-hyprland-wrapped
                killall .xdg-desktop-portal-gtk-wrapped
                killall .xdg-desktop-portal-wrapped

                logger 'killed all xdg-desktop-portals'
                sleep 2
                ${pkgs.xdg-desktop-portal-gtk}/libexec/xdg-desktop-portal-gtk &
                logger 'xdg-desktop-portal-gtk started'
                sleep 2
                ${pkgs.xdg-desktop-portal-hyprland}/libexec/xdg-desktop-portal-wlr &
                logger 'xdg-desktop-portal-wlr started'
                sleep 2
                ${pkgs.xdg-desktop-portal-hyprland}/libexec/xdg-desktop-portal-hyprland &
                logger 'xdg-desktop-portal-hyprland started'
                sleep 2
                ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal &
                logger 'xdg-desktop-portal started'
            '')
        ];

        security.polkit.enable = true;
        services.gnome.gnome-keyring.enable = true;

        systemd = {
            user.services.polkit-gnome-authentication-agent-1 = {
                description = "polkit-gnome-authentication-agent-1";
                wantedBy = ["graphical-session.target"];
                wants = ["graphical-session.target"];
                after = ["graphical-session.target"];
                serviceConfig = {
                    Type = "simple";
                    ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
                    Restart = "on-failure";
                    RestartSec = 1;
                    TimeoutStopSec = 10;
                };
            };
        };

        environment.sessionVariables = {
           __EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json";

            VK_ICD_FILENAMES          = lib.mkDefault "${pkgs.mesa}/share/vulkan/icd.d/radeon_icd.x86_64.json";
            VK_LOADER_DRIVERS_DISABLE = lib.mkDefault "${pkgs.mesa}/share/vulkan/icd.d/nouveau_icd.x86_64.json";
        };

        hardware.graphics.enable = true;
    };
}
