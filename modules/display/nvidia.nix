{ lib, config, pkgs, ... }: {
    config = lib.mkMerge [
        (lib.mkIf config.display.nvidia.enable {
            services.xserver.videoDrivers = [ "nvidia" ];

            boot.blacklistedKernelModules = [ "nouveau" ];
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

            environment.sessionVariables = {
                VK_LOADER_DRIVERS_DISABLE = lib.mkDefault "${pkgs.mesa}/share/vulkan/icd.d/nouveau_icd.x86_64.json";
            };
        })
        (lib.mkIf (config.display.nvidia.enable && config.display.nvidia.prime.enable) {
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
                (writeShellScriptBin "check-gpu-usage" (lib.readFile ../../scripts/nvidia/check-gpu-usage.sh))
                (writeShellScriptBin "prime-run-base"  (lib.readFile ../../scripts/nvidia/prime-run-base.sh))
                (writeShellScriptBin "prime-run"       (lib.readFile ../../scripts/nvidia/prime-run.sh))
            ];

            environment.sessionVariables = {
                VK_LOADER_DRIVERS_DISABLE = "${pkgs.mesa}/share/vulkan/icd.d/nouveau_icd.x86_64.json,${config.boot.kernelPackages.nvidiaPackages.latest}/share/vulkan/icd.d/nvidia_icd.x86_64.json";
            };
        })
    ];
}
