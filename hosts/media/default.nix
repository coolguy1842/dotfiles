{ lib, config, pkgs, username, ... }: {
    users.defaultUserShell = pkgs.bash;
    
    users.users."${username}" = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "dialout" ];
    };
}