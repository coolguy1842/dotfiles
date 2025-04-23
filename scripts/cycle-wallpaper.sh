wallpaper_directory="$HOME/Pictures/Wallpapers"

export SWWW_TRANSITION_FPS=165
export SWWW_TRANSITION_STEP=90
export SWWW_TRANSITION=wipe
export SWWW_TRANSITION_ANGLE=45

current_wallpaper="$(swww query | grep -Eio "image: .*" | grep -Eio "/.*\..*" -A 0 | head -1)"
ls "$wallpaper_directory" | sort -R | tail -$N | while read file; do
    new_wallpaper="$wallpaper_directory/$file"
    if [[ $current_wallpaper == $new_wallpaper ]]; then
        continue
    fi

    swww img "$wallpaper_directory/$file"
    break
done