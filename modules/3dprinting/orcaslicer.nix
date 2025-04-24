{ lib, config, pkgs, ... }: {
    options.orca-slicer.enable = lib.mkEnableOption "Enable OrcaSlicer";

    config = lib.mkIf config.orca-slicer.enable {
        users.users.coolguy.packages = with pkgs; [
            orca-slicer
        ];
    };
}