{ lib, moduleConfig, ... }: {
    wayland.windowManager.hyprland.settings.monitor = lib.mapAttrsToList (name: monitor: 
        "${name}, ${monitor.resolution}${if monitor.refreshRate != null then "@${toString monitor.refreshRate}" else ""}, ${monitor.position}, ${toString monitor.scaling}"
    ) moduleConfig.hyprland.monitors;
}
