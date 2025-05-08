{ lib, cfg, ... }: {
    wayland.windowManager.hyprland.settings.monitor = lib.mapAttrsToList (name: monitor: 
        "${name}, " +
        "${monitor.resolution}${if monitor.refreshRate != null then "@${toString monitor.refreshRate}" else ""}, " +
        "${monitor.position}, " +
        "${toString monitor.scaling}, " +
        "transform, ${toString monitor.transform}, " +
        "bitdepth, ${toString monitor.bitdepth}," + 
        "cm, ${monitor.cm}, " +
        "sdrbrightness, ${toString monitor.sdrbrightness}, " +
        "sdrsaturation, ${toString monitor.sdrsaturation}, " +
        "vrr, ${toString monitor.vrr}"
    ) cfg.display.hyprland.monitors;
}
