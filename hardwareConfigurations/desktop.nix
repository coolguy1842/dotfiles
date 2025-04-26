{ config, lib, pkgs, modulesPath, ... }: {
    imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = [ "nvme" "ahci" "xhci_pci" "usb_storage" "usbhid" "uas" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-amd" ];
    boot.extraModulePackages = [ ];
    
    fileSystems."/" = {
        device = "/dev/disk/by-uuid/3311c0cf-eea9-47ce-bb4a-0fd52fbb070b";
        fsType = "ext4";
    };

    fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/C533-3787";
        fsType = "vfat";
        
        options = [ "fmask=0077" "dmask=0077" ];
    };

    fileSystems."/mnt/other" = {
        device = "/dev/disk/by-uuid/e90ef8fb-e554-40f0-b7a7-6f694f37c41d";
        fsType = "btrfs";
        
        options = [ "nofail" "x-systemd.automount" ];
    };

    swapDevices = [
        {device = "/dev/disk/by-uuid/bcaee000-f33a-409c-b5fb-8f9018422953"; }
    ];

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
