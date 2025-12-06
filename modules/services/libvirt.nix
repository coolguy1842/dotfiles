{ lib, config, pkgs, ... }: {
    config = lib.mkIf config.services.libvirt.enable {
        virtualisation.libvirtd = {
            enable = true;
            qemu = {
                package = pkgs.qemu_kvm;
                runAsRoot = true;
            };
        };

        environment.systemPackages = with pkgs; [
            virt-manager
        ];
    };
}