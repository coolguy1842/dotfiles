{ config, lib, pkgs, ... }: {
    config = lib.mkMerge [
        (lib.mkIf config.games.steam.enable {
            programs.steam = {
                enable = true;
                package = with pkgs; steam.override {
                    extraPkgs = pkgs: [
                        xorg.libXcursor
                        xorg.libXi
                        xorg.libXinerama
                        xorg.libXScrnSaver

                        libpng
                        libpulseaudio
                        libvorbis
                        libkrb5
                        
                        stdenv.cc.cc.lib
                        keyutils
                    ];
                };
            };

            environment.systemPackages = with pkgs; [
                protonup-qt
            ];

            # horizon fw bugs out with audio from nofiles
            security.pam.loginLimits = [
                { domain = "*"; type = "soft"; item = "nofile"; value = "8192";     }
                { domain = "*"; type = "hard"; item = "nofile"; value = "infinity"; }
            ];
        })
        (lib.mkIf config.games.steam.remote-play.enable {
            services.flatpak.enable = true;
            services.flatpak.remotes = [ { name = "flathub"; location = "https://flathub.org/repo/flathub.flatpakrepo"; } ];
            services.flatpak.packages = [ "com.valvesoftware.SteamLink" ];
        })
    ];
}