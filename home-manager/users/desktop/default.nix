{ inputs, pkgs, ... }: {
    imports = [
        ../../default.nix
        ./binds.nix
        ./execs.nix
        ./looking-glass.nix
    ];

    wayland.windowManager.hyprland.settings = {
        workspace = [
            "special:capturecard, on-created-empty: ${inputs.capturecardrelay.packages.${pkgs.system}.default}/bin/CaptureCardRelay"
        ];

        windowrule = [
            "fullscreen, initialClass:^(CaptureCardRelay)$"
            "noscreenshare, initialClass:^(Proton Pass)$"
            "noscreenshare, initialClass:^(io.ente.auth)$"
            "noscreenshare, initialClass:^(electron-mail)$"
            "noscreenshare, initialClass:^(Element)$"
        ];

        debug = {
            full_cm_proto = true;
        };
    };
}