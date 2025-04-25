{
    description = "NixOS Config";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        
        etc-nixos = {
            url = "path:/etc/nixos";
            flake = false;
        };

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

    outputs = { nixpkgs, nix-flatpak, etc-nixos, home-manager, ... } @ inputs: {
        nixosConfigurations = {
            desktop = let username = "coolguy"; in nixpkgs.lib.nixosSystem {
                modules = [
                    "${etc-nixos}/hardware-configuration.nix"
                    nix-flatpak.nixosModules.nix-flatpak
                    ./configs
                    ./modules
                    ./hosts/desktop
                    home-manager.nixosModules.home-manager {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;

                        home-manager.users."${username}" = import ./home-manager/default.nix;
                    }
                    { nixpkgs.hostPlatform = "x86_64-linux"; }
                    { nixpkgs.config.allowUnfree = true; }
                ];

                specialArgs = { inherit inputs username; };
            };
            
            media = let username = "media"; in nixpkgs.lib.nixosSystem {
                modules = [
                    "${etc-nixos}/hardware-configuration.nix"
                    nix-flatpak.nixosModules.nix-flatpak
                    ./configs
                    ./modules
                    ./hosts/media
                    home-manager.nixosModules.home-manager {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;

                        home-manager.users."${username}" = import ./home-manager/users/media.nix;
                    }
                    { nixpkgs.hostPlatform = "x86_64-linux"; }
                    { nixpkgs.config.allowUnfree = true; }
                ];

                specialArgs = { inherit inputs username; };
            };
        };
    };
}