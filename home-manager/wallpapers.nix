{ pkgs, ... }: let 
    wallpaperPath = "Wallpapers";
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
            ls "$HOME/${wallpaperPath}" | sort -R | tail -$N | while read file; do
                new_wallpaper="$HOME/${wallpaperPath}/$file"
                if [[ $current_wallpaper == $file ]]; then
                    continue
                fi

                swww img "$HOME/${wallpaperPath}/$file"
                break
            done
        '')
    ];

    home.file."${wallpaperPath}" = {
        source = ../wallpapers;
        recursive = true;
    };
}