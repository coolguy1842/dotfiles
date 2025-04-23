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
            
#            __EGL_VENDOR_LIBRARY_FILENAMES = "${pkgs.mesa}/share/egl_vendor.d/50_mesa.json";
            VK_LOADER_DRIVERS_DISABLE = "nvidia_icd.json";
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
