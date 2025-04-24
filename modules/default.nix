{ ... }: let
    userPkgs = [];
in {
    imports = [
        ./display
        ./applications
        ./3dprinting
    ];
}