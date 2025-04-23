{ config, ... }: let 
    specialWorkspace = name: key: [
        "$mod, ${key}, togglespecialworkspace, ${name}"
        "$mod SHIFT, ${key}, movetoworkspace, special:${name}"
    ];
in {
    wayland.windowManager.hyprland.settings."$menu" = "printf \"app_launcher\" | socat - UNIX-CONNECT:/tmp/coolguy/ags/socket";
    wayland.windowManager.hyprland.settings."$picker" = "hyprpicker";
    wayland.windowManager.hyprland.settings."$screenshot" = "hyprshade off; wayfreeze & PID=$!; sleep .1; grim -g \"$(slurp)\" - | wl-copy; kill $PID; hyprshade on vibrance";

    wayland.windowManager.hyprland.settings."$mod" = "SUPER";
    wayland.windowManager.hyprland.settings."$modLeft" = "SUPER_L";
    wayland.windowManager.hyprland.settings."$modRight" = "SUPER_R";
    wayland.windowManager.hyprland.settings.binds = {
        scroll_event_delay = 0;
    };

    wayland.windowManager.hyprland.settings.bind = [
        "$mod, W, exec, zen"
        "$mod, T, exec, kitty"
        "$mod, N, exec, nautilus"
        "$mod, Q, killactive"
        "$mod SHIFT, BACKSPACE, exit"
        "$mod, F, togglefloating,"
        "$mod, SPACE, exec, $menu"
        "ALT, SPACE, exec, qdbus com.coolguy1842.Widgets /Widgets ToggleQuickLauncher"
        "$mod, P, exec, $picker"
        "$mod, J, togglesplit,"

        "ALT, left, movefocus, l"
        "ALT, right, movefocus, r"
        "ALT, up, movefocus, u"
        "ALT, down, movefocus, d"

        "$mod, mouse_down, workspace, m+1"
        "$mod, mouse_up, workspace, m-1"

        "$mod, M, fullscreen"
        ",Print, exec, $screenshot"

        "ALT, Tab, cyclenext,"
        "ALT, Tab, bringactivetotop,"
        "ALT SHIFT, Tab, cyclenext, prev"
        "ALT SHIFT, Tab, bringactivetotop,"

        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ] ++ (
        builtins.concatLists (
            builtins.genList (i:
                let ws = i + 1; in [
                    "$mod, code:1${toString i}, workspace, name:${config.mainMonitor.name}|${toString ws}"
                    "$mod SHIFT, code:1${toString i}, movetoworkspace, name:${config.mainMonitor.name}|${toString ws}"
                    ]
                )
            config.mainMonitor.workspaces
        )
    ) ++ (
        builtins.concatLists (
            builtins.genList (i:
                let ws = i + 1; in [
                    "$mod ALT, code:1${toString i}, workspace, name:${config.secondMonitor.name}|${toString ws}"
                    "$mod ALT SHIFT, code:1${toString i}, movetoworkspace, name:${config.secondMonitor.name}|${toString ws}"
                ]
            )
            config.secondMonitor.workspaces
        )
    )
    ++ specialWorkspace "discord" "D"
    ++ specialWorkspace "music" "S"
    ++ specialWorkspace "email" "E";
        
    wayland.windowManager.hyprland.settings.binde = [
        "$mod, RIGHT, workspace, m+1"
        "$mod, LEFT, workspace, m-1"
        "$mod SHIFT, RIGHT, movetoworkspace, e+1"
        "$mod SHIFT, LEFT, movetoworkspace, e-1"

        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.25"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        
    ];

    wayland.windowManager.hyprland.settings.bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
    ];
} 
