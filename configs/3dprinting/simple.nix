{ lib, ... }: {
    options."3dprinting" = {
        orca-slicer.enable = lib.mkEnableOption "Enable OrcaSlicer";
    };
}