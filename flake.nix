{
    description = "NixOS Config";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        
        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs, home-manager, ... } @ inputs: {
        nixosConfigurations = {
            coolguy = nixpkgs.lib.nixosSystem {
                modules = [
                    ./hosts/coolguy.nix
                    ./modules
                    { nixpkgs.hostPlatform = "x86_64-linux"; }
                    { nixpkgs.config.allowUnfree = true; }
                    home-manager.nixosModules.home-manager {
                        home-manager.useGlobalPkgs = true;
                        home-manager.useUserPackages = true;

                        home-manager.users.coolguy = import ./home-manager/default.nix;
                        home-manager.extraSpecialArgs = {
                            inherit inputs;
                            self = inputs.self;
                        };
                    }
                ];

                specialArgs = { inherit inputs; };
            };
        };
    };
}