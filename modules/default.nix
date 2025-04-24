{ ... }: let
    userPkgs = [];
in {
    imports = [
        ./services
        ./display
        ./applications
        ./media
        ./games
        ./3dprinting
    ];
}