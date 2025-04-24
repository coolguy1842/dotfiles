{ lib, config, pkgs, ... }: {
    config = lib.mkIf config.applications.blender.enable {
        environment.systemPackages = with pkgs; [
            (blender.override { cudaSupport = config.display.nvidia.cuda.enable; })
        ];
    };
}