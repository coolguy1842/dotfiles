{ lib, config, pkgs, username, ... }: {
    imports = [
        ../common.nix
        ./config.nix
    ];

    users.defaultUserShell = pkgs.bash;
    
    users.users."${username}" = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "dialout" ];
    };
}