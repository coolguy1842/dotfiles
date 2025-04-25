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
                xdg-desktop-portal-hyprland
            ];
            
            config = {
                common = {
                    default = [
                        "gtk"
                        "hyprland"
                    ];
                };
            };
        };

        environment.systemPackages = with pkgs; [
            libnotify
            hyprland-protocols
            polkit
            polkit_gnome
            grim
            slurp
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

        hardware.graphics.enable = true;
    };
}
