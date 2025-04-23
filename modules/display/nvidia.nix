{ lib, config, pkgs, ... }: {
    options.nvidia.enable = lib.mkEnableOption "Enable NVIDIA";
    options.nvidia.prime.enable = lib.mkEnableOption "Enable NVIDIA-Prime";

    config = lib.mkMerge [
        (lib.mkIf config.nvidia.enable {
            services.xserver.videoDrivers = [ "amdgpu" "nvidia"];
            hardware = {
                graphics.enable = true;  

                nvidia = {
                    modesetting.enable = true;
                    powerManagement.enable = false;
                    powerManagement.finegrained = false;

                    open = true;
                    nvidiaSettings = true;

                    package = config.boot.kernelPackages.nvidiaPackages.latest;
                };
            };
        })
        (lib.mkIf (config.nvidia.enable && config.nvidia.prime.enable) {
            hardware.nvidia.prime = {
                offload = {
                    enable = true;
                    enableOffloadCmd = false;
                };
                
                amdgpuBusId = "PCI:11:0:0";
                nvidiaBusId = "PCI:01:0:0";
            };

            environment.systemPackages = with pkgs; [
                lsof
                (writeShellScriptBin "check-gpu-usage" (builtins.readFile ../../scripts/nvidia/check-gpu-usage.sh))
                (writeShellScriptBin "prime-run-base"  (builtins.readFile ../../scripts/nvidia/prime-run-base.sh))
                (writeShellScriptBin "prime-run"       (builtins.readFile ../../scripts/nvidia/prime-run.sh))
            ];

            environment.sessionVariables = {
                VK_LOADER_DRIVERS_DISABLE = "${pkgs.mesa}/share/vulkan/icd.d/nouveau_icd.x86_64.json,${config.boot.kernelPackages.nvidiaPackages.latest}/share/vulkan/icd.d/nvidia_icd.x86_64.json";
            };
        })
    ];
}
