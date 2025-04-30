{ lib, config, pkgs, ... }: {
    config = lib.mkIf config.services.libvirt.enable {
        virtualisation.libvirtd = {
            enable = true;
            qemu = {
                package = pkgs.qemu_kvm;
                runAsRoot = true;
                
                ovmf = {
                    enable = true;
                    packages = [(pkgs.OVMF.override {
                        secureBoot = true;
                        tpmSupport = true;
                    }).fd];
                };
            };
        };

        environment.systemPackages = with pkgs; [
            virt-manager
        ];
    };
}