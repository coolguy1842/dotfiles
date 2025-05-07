{ pkgs, ... }: {
    imports = [
        ../../default.nix
        ./binds.nix
        ./execs.nix
        ./looking-glass.nix
    ];

}