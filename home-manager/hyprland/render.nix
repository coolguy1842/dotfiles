{ lib, config, cfg, ... }: {
    home.activation.linkDRMDevices = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        outdir="${config.xdg.configHome}/hypr"
        for oldcard in $(find "$outdir" -maxdepth 1 -name 'card[0-9]*' -type l); do unlink $oldcard; done
        i=0
        for path in ${toString cfg.display.hyprland.drmDevices}; do
            ln -sf "/dev/dri/by-path/$path" $outdir/card$i
            i=$(expr $i + 1)
        done

    '';
    
    wayland.windowManager.hyprland.settings.env = ( if cfg.display.hyprland.drmDevices != [] then [
        "AQ_DRM_DEVICES,${
            lib.strings.concatMapStringsSep ":" (str: str) (
                lib.genList (i: "${config.xdg.configHome}/hypr/card${toString i}") (lib.length cfg.display.hyprland.drmDevices)
            )
        }"
    ] else [] );

    wayland.windowManager.hyprland.settings.render = {
        explicit_sync = 1;
        explicit_sync_kms = 1;
        direct_scanout = false;
    };
}
