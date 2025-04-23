{
    description = "NixOS Config";
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        
        etc-nixos = {
            url = "/etc/nixos";
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
    };

    outputs = { nixpkgs, home-manager, ... } @ inputs: {
        nixosConfigurations = {
            coolguy = nixpkgs.lib.nixosSystem {
                modules = [
                    {
                        imports = if (builtins.pathExists "${inputs.etc-nixos}/hardware-configuration.nix")
                            then [ (import "${inputs.etc-nixos}/hardware-configuration.nix") ]
                            else [];
                        assertions = [
                            {
                                assertion = builtins.pathExists "${inputs.etc-nixos}/hardware-configuration.nix";
                                message = "The hardware-configuration file is missing at ${inputs.etc-nixos}/hardware-configuration.nix";
                            }
                        ];
                    }
                    ./hosts/coolguy
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