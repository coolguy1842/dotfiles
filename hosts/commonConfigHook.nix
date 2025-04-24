{ inputs, config, ... }: {
    home-manager.extraSpecialArgs = {
        inherit inputs;
        self = inputs.self;

        cfg = config;
    };
}