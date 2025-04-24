{ lib, config, pkgs, ... }: let 
    waveeffect = pkgs.stdenv.mkDerivation rec {
        name = "waveeffect";
        src = pkgs.fetchFromGitHub {
            owner = "coolguy1842";
            repo = "waveeffect";
            rev = "master";
            sha256 = "vfURV34o4EVjR7YOtMfocvBSIQpSMgHNbIzGZp9SxQc=";
        };

        nativeBuildInputs = [
            pkgs.pkg-config
            pkgs.ninja
            pkgs.cmake
            pkgs.meson
        ];

        buildInputs = [
            pkgs.hidapi
            pkgs.libvirt
            pkgs.libevdev
        ];

        mesonFlags = [ "--prefix=$out" ];    
        configurePhase = ''
            meson setup build ${toString mesonFlags}
        '';
        
        buildPhase = ''
            ninja -C build
        '';
        
        installPhase = ''
            ninja -C build install
        '';
    };
in {
    config = lib.mkIf config.services.waveeffect.enable {
        environment.systemPackages = [
            waveeffect
        ];

        systemd.services.waveeffect = {
            enable = true;
            serviceConfig = {
                ExecStart = "${waveeffect}/bin/wave";
            };

            wantedBy = [ "default.target" ];
        };
    };
}