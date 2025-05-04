{ lib, cfg, ... }: let 
    getAllWorkspaces = import ./util/getAllWorkspaces.nix { inherit lib; };
in {
    wayland.windowManager.hyprland.settings.workspace = (lib.forEach (getAllWorkspaces cfg.display.hyprland.monitors) (workspace:
        "${toString workspace.id},${if workspace.name != null then " defaultName:${workspace.name}," else ""} default:${if workspace.index == 0 then "true" else "false"}, monitor:${workspace.monitor.name}, persistent:true"
    ));
}
