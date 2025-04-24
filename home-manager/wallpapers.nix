{ pkgs, ... }: let 
    wallpaperPath = "${config.xdg.configHome}/wallpapers";
in {
    home.packages = with pkgs; [
        swww
        waypaper
        (writeShellScriptBin "cycle-wallpaper" ''
            export SWWW_TRANSITION_FPS=165
            export SWWW_TRANSITION_STEP=90
            export SWWW_TRANSITION=wipe
            export SWWW_TRANSITION_ANGLE=45

            current_wallpaper="$(basename "$(swww query | grep -Eio "image: .*" | grep -Eio "/.*\..*" -A 0 | head -1)")"
            ls "$${wallpaperPath}" | sort -R | tail -$N | while read file; do
                new_wallpaper="${wallpaperPath}/$file"
                if [[ $current_wallpaper == $file ]]; then
                    continue
                fi

                swww img "${wallpaperPath}/$file"
                break
            done
        '')
    ];

    home.file."${wallpaperPath}" = {
        source = ../wallpapers;
        recursive = true;
    };
}