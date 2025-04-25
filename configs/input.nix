{ lib, config, ... }: {
    options.input = with lib; {
        sensitivity = mkOption { type = types.float; default = 0.0; description = "mouse sensitivity from -1.0 to 1.0"; };
        keyboardLayout = mkOption { type = types.str; default = "us"; };
        locale = mkOption { type = types.str; default = "en_AU.UTF-8"; };
    };
}