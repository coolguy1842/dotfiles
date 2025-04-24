{ lib, moduleConfig, self, ... }: {
    wayland.windowManager.hyprland.settings."$menu" = "printf \"app_launcher\" | socat - UNIX-CONNECT:/tmp/coolguy/ags/socket";
    wayland.windowManager.hyprland.settings."$picker" = "hyprpicker";
    wayland.windowManager.hyprland.settings."$screenshot" = "hyprshade off; wayfreeze & PID=$!; sleep .1; grim -g \"$(slurp)\" - | wl-copy; kill $PID; hyprshade on vibrance";

    wayland.windowManager.hyprland.settings.binds = {
        scroll_event_delay = 0;
    };

    wayland.windowManager.hyprland.settings.bind = [
        "${moduleConfig.hyprland.modifier}, W, exec, zen"
        "${moduleConfig.hyprland.modifier}, T, exec, kitty"
        "${moduleConfig.hyprland.modifier}, N, exec, nautilus"
        "${moduleConfig.hyprland.modifier}, Q, killactive"
        "${moduleConfig.hyprland.modifier} SHIFT, BACKSPACE, exit"
        "${moduleConfig.hyprland.modifier}, F, togglefloating,"
        "${moduleConfig.hyprland.modifier}, SPACE, exec, $menu"
        "ALT, SPACE, exec, qdbus com.coolguy1842.Widgets /Widgets ToggleQuickLauncher"
        "${moduleConfig.hyprland.modifier}, P, exec, $picker"
        "${moduleConfig.hyprland.modifier}, J, togglesplit,"

        "ALT, left, movefocus, l"
        "ALT, right, movefocus, r"
        "ALT, up, movefocus, u"
        "ALT, down, movefocus, d"

        "${moduleConfig.hyprland.modifier}, mouse_down, workspace, m+1"
        "${moduleConfig.hyprland.modifier}, mouse_up, workspace, m-1"

        "${moduleConfig.hyprland.modifier}, M, fullscreen"
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
        lib.flatten (lib.mapAttrsToList (name: monitor: (
            builtins.genList (i:
                let ws = i + 1; in [
                    "${monitor.workspaceBind}, code:1${toString i}, workspace, name:${name}|${toString ws}"
                    "${monitor.workspaceBind} SHIFT, code:1${toString i}, movetoworkspace, name:${name}|${toString ws}"
                    ]
                )
            monitor.workspaces
        )) moduleConfig.hyprland.monitors)
    ) ++ (
        lib.flatten (lib.mapAttrsToList (name: workspace: ([
                "${workspace.modifier}, ${workspace.keybind}, togglespecialworkspace, ${name}"
                "${workspace.moveModifier}, ${workspace.keybind}, movetoworkspace, special:${name}"
            ])) moduleConfig.hyprland.specialWorkspaces
        )
    );
        
    wayland.windowManager.hyprland.settings.binde = [
        "${moduleConfig.hyprland.modifier}, RIGHT, workspace, m+1"
        "${moduleConfig.hyprland.modifier}, LEFT, workspace, m-1"
        "${moduleConfig.hyprland.modifier} SHIFT, RIGHT, movetoworkspace, e+1"
        "${moduleConfig.hyprland.modifier} SHIFT, LEFT, movetoworkspace, e-1"

        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.25"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        
    ];

    wayland.windowManager.hyprland.settings.bindm = [
        "${moduleConfig.hyprland.modifier}, mouse:272, movewindow"
        "${moduleConfig.hyprland.modifier}, mouse:273, resizewindow"
    ];
} 
