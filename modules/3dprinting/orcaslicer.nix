{ lib, config, pkgs, ... }: {
    config = lib.mkIf config."3dprinting".orca-slicer.enable {
        environment.systemPackages = with pkgs; [
            orca-slicer
        ];
    };
}