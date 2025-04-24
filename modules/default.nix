{ ... }: let
    userPkgs = [];
in {
    imports = [
        ./services
        ./display
        ./applications
        ./games
        ./3dprinting
    ];
}