{ lib, config, pkgs, ... }: {
    options.hyprland.enable = lib.mkEnableOption "Enable Hyprland";

    config = lib.mkIf config.hyprland.enable {
        programs.hyprland = {
            enable = true;
            xwayland.enable = true;
        };

        xdg.portal = {
            enable = true;
            xdgOpenUsePortal = true;
            extraPortals = with pkgs; [
                xdg-desktop-portal-gtk
                xdg-desktop-portal-hyprland
            ];
        };

        environment.systemPackages = with pkgs; [
            (writeShellScriptBin "cycle-wallpaper" (builtins.readFile ../../scripts/cycle-wallpaper.sh))
            (writeShellScriptBin "load-portals" ''
                killall xdg-desktop-portal-hyprland
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
                ${pkgs.xdg-desktop-portal-hyprland}/libexec/xdg-desktop-portal-hyprland &
                logger 'xdg-desktop-portal-hyprland started'
                sleep 2
                ${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal &
                logger 'xdg-desktop-portal started'
            '')
        ];

        users.users.coolguy = {
            packages = with pkgs; [
                grim
                slurp
                wl-clipboard
                clipman
                hyprpicker
                hyprshade
                libnotify
                waypaper
                swww
                polkit
                polkit_gnome
                gtk4
                gtk3
                qt6.full
                hyprland-protocols
                xdg-desktop-portal-gtk
                xdg-desktop-portal-hyprland
            ];
        };

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

        security.polkit.extraConfig = ''
            polkit.addRule(function(action, subject) {
                if(
                    subject.user == "coolguy"
                    && (
                        action.id.indexOf("org.freedesktop.NetworkManager.") == 0 ||
                        action.id.indexOf("org.freedesktop.ModemManager") == 0
                    )
                ) {
                    return polkit.Result.YES;
                }
            });

            polkit.addRule(function(action, subject) {
            if(
                subject.isInGroup("users")
                && (
                    action.id == "org.freedesktop.login1.reboot" ||
                    action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                    action.id == "org.freedesktop.login1.power-off" ||
                    action.id == "org.freedesktop.login1.power-off-multiple-sessions"
                )
                ) {
                    return polkit.Result.YES;
                }
            });
        '';

        environment.sessionVariables = {
            XDG_CURRENT_DESKTOP = "Hyprland";
            XDG_SESSION_TYPE = "wayland";
            XDG_SESSION_DESKTOP = "Hyprland";

            QT_QPA_PLATFORM = "wayland;xcb";
            
           __EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa}/share/glvnd/egl_vendor.d/50_mesa.json";
            VK_ICD_FILENAMES          = lib.mkDefault "${pkgs.mesa}/share/vulkan/icd.d/radeon_icd.x86_64.json";
            VK_LOADER_DRIVERS_DISABLE = lib.mkDefault "${pkgs.mesa}/share/vulkan/icd.d/nouveau_icd.x86_64.json";
        };

        hardware.graphics.enable = true;
        systemd.user.targets.hyprland-session = {
            unitConfig = {
                Description = "Hyprland Session";
                BindsTo = [ "graphical-session.target" ];
                Wants = [ "graphical-session-pre.target" "xdg-desktop-autostart.target" ];
                After = [ "graphical-session-pre.target" ];
                Before = [ "xdg-desktop-autostart.target" ];
            };
        };
    };
}
