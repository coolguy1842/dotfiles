{ lib, moduleConfig, ... }: {
    # presume first monitor in list is primary
    wayland.windowManager.hyprland.settings.workspace = [
        "name:windows, monitor:${moduleConfig.hyprland.mainMonitor}" # workspace for looking glass
    ] ++ (
        lib.flatten (lib.mapAttrsToList (name: monitor: (
            builtins.genList(i:
                let wsName = "${name}|${toString (i + 1)}"; ws = monitor.workspaceOffset + i + 1; in [
                    "${toString ws}, defaultName:${wsName}, default:${if i == 0 then "true" else "false"}, monitor:${name}, persistent:true"
                ]
            ) monitor.workspaces
        )) moduleConfig.hyprland.monitors)
    );
}
