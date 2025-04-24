{ inputs, config, username, ... }: {
    home-manager.extraSpecialArgs = {
        inherit inputs username;
        
        self = inputs.self;
        cfg = config;
    };
}