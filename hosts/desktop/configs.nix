{ lib, config, ... }: {
    nvidia.enable = true;
    nvidia.prime.enable = true;
    
    discord.enable = true;
    steam.enable = true;
    sober.enable = true;

    orca-slicer.enable = true;
    
    hyprland = {
        enable = true;
        drmDevices = "/dev/dri/pci-0000:11:00.0-card";

        mainMonitor = "DP-1";
        monitors = {
            DP-1     = { workspaces = 9; resolution = "1920x1080"; refreshRate = 165; position = "1680x0"; };
            HDMI-A-1 = { workspaces = 1; resolution = "1680x1050"; refreshRate = 60; position = "0x30"; workspaceBind = "${config.hyprland.modifier} ALT"; workspaceOffset = 9; };
        };

        specialWorkspaces = {
            discord.keybind = "D";
            music.keybind = "S";
            email.keybind = "E";
        };    
    };
}