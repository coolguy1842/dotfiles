{ lib, ... }: {
    options.display = {
        ags.enable = lib.mkEnableOption "Enable AGS";

        nvidia = {
            enable = lib.mkEnableOption "Enable NVIDIA";
            prime.enable = lib.mkEnableOption "Enable NVIDIA-Prime";
            cuda.enable = lib.mkEnableOption "Enable CUDA";
        };
    };
}