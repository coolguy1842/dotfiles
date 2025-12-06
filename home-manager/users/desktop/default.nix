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
            "fullscreen, initialTitle:^(CaptureCardRelay)$"
            "noscreenshare, initialClass:^(Proton Pass)$"
            "noscreenshare, initialClass:^(io.ente.auth)$"
            "noscreenshare, initialClass:^(electron-mail)$"
            "noscreenshare, initialClass:^(Element)$"
            "noscreenshare, initialClass:^(Signal)$"
            "noscreenshare, initialClass:^(librewolf)$"
            "noscreenshare, initialTitle:^(Among Us)$"
        ];

        debug = {
            full_cm_proto = true;
        };
    };
}