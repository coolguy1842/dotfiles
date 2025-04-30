{
    description = "NixOS Config";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        zen-browser = {
            url = "github:0xc000022070/zen-browser-flake";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        ags = {
            url = "github:coolguy1842/agsv1/v1";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        nix-flatpak = {
            url = "github:gmodena/nix-flatpak";
        };
    };

    outputs = { nixpkgs, nix-flatpak, home-manager, ... } @ inputs: let 
        defaultConfig = configName: username: nixpkgs.lib.nixosSystem {
            modules = [
                ./hardwareConfigurations/${configName}.nix
                nix-flatpak.nixosModules.nix-flatpak
                ./configs
                ./hosts/${configName}
                home-manager.nixosModules.home-manager {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;

                    home-manager.users."${username}" = import ./home-manager/users/${configName}.nix;
                }
                { nixpkgs.hostPlatform = "x86_64-linux"; }
                { nixpkgs.config.allowUnfree = true; }
            ];

            specialArgs = { inherit inputs username; };
        };
    in {
        nixosConfigurations = {
            desktop = defaultConfig "desktop" "coolguy";
            media = let username = "media"; in nixpkgs.lib.nixosSystem {
                modules = [
                    ./hardwareConfigurations/media.nix
                    nix-flatpak.nixosModules.nix-flatpak
                    ./configs
                    ./hosts/media
                    { nixpkgs.hostPlatform = "x86_64-linux"; }
                    { nixpkgs.config.allowUnfree = true; }
                ];


                specialArgs = { inherit inputs username; };
            };
        };
    };
}