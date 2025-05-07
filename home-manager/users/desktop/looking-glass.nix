{ ... }: let 
    patchedLG = pkgs.looking-glass-client.overrideAttrs (old: {
        patches = (old.patches or []) ++ [
            ../../patches/looking-glass-super.patch
        ];
    });
in {
    wayland.windowManager.hyprland.settings.workspace = [
        "special:windows, on-created-empty: ${patchedLG}/bin/looking-glass-client"
    ];

    programs.looking-glass-client = {
        enable = true;

        settings = {
            win = {
                fullscreen = "yes";
                title = "Win10";
            };

            input = {
                rawMouse = "yes";
                ignoreWindowsKeys = "yes";
                escapeKey = 74;
            };

            spice = {
                alwaysShowCursor = "yes";
                audio = "yes";
            };

            egl = {
                mapHDRtoSDR = "no";
            };
        };
    };
}