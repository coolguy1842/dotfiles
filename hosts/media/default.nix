{ lib, config, inputs, pkgs, username, ... }: {
    imports = [
        ../common.nix
        ./config.nix
        ./packages.nix
    ];

    boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
    };

    networking = {
        networkmanager.enable = true;
        firewall.enable = true;
    };

    services = {
        dbus.enable = true;
        getty.autologinUser = "${username}";
    };

    users.defaultUserShell = pkgs.bash;    
    users.users."${username}" = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" "dialout" ];
    };
}
