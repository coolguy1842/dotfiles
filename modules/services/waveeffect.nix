{ lib, inputs, config, pkgs, ... }: let 
    wavepackage = inputs.waveeffect.packages.${pkgs.system}.default;
in {
    config = lib.mkIf config.services.waveeffect.enable {
        environment.systemPackages = [
            wavepackage
        ];

        systemd.services.waveeffect = {
            enable = true;
            serviceConfig = {
                ExecStart = "${wavepackage}/bin/waveeffect";
            };

            wantedBy = [ "default.target" ];
        };
    };
}