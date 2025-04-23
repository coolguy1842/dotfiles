{ config, ... }: {
    wayland.windowManager.hyprland.settings.workspace = [
        "name:windows, monitor:${config.mainMonitor.name}" # workspace for looking glass
    ] ++ (
        builtins.concatLists (
            builtins.genList(i:
                let wsName = "${config.mainMonitor.name}|${toString (i + 1)}"; ws = i + 1; in [
                    "${toString ws}, defaultName:${wsName}, default:${if i == 0 then "true" else "false" }, monitor:${config.mainMonitor.name}, persistent:true"
                ]
            )
            config.mainMonitor.workspaces
        )
    ) ++ (
        builtins.concatLists (
            builtins.genList(i:
                let wsName = "${config.secondMonitor.name}|${toString (i + 1)}"; ws = config.mainMonitor.workspaces + i + 1; in [
                    "${toString ws}, defaultName:${wsName}, default:${if i == 0 then "true" else "false"}, monitor:${config.secondMonitor.name}, persistent:true"
                ]
            )
            config.secondMonitor.workspaces
        )
    );
}
