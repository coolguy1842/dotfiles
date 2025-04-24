{ lib, cfg, self, ... }: let 
    getAllWorkspaces = import ./util/getAllWorkspaces.nix { inherit lib; };
in {
    wayland.windowManager.hyprland.settings."$menu" = "printf \"app_launcher\" | socat - UNIX-CONNECT:/tmp/coolguy/ags/socket";
    wayland.windowManager.hyprland.settings."$picker" = "hyprpicker";
    wayland.windowManager.hyprland.settings."$screenshot" = "hyprshade off; wayfreeze & PID=$!; sleep .1; grim -g \"$(slurp)\" - | wl-copy; kill $PID; hyprshade on vibrance";

    wayland.windowManager.hyprland.settings.binds = {
        scroll_event_delay = 0;
    };

    wayland.windowManager.hyprland.settings.bind = [
        "${cfg.display.hyprland.modifier}, W, exec, zen"
        "${cfg.display.hyprland.modifier}, T, exec, kitty"
        "${cfg.display.hyprland.modifier}, N, exec, nautilus"
        "${cfg.display.hyprland.modifier}, Q, killactive"
        "${cfg.display.hyprland.modifier} SHIFT, BACKSPACE, exit"
        "${cfg.display.hyprland.modifier}, F, togglefloating,"
        "${cfg.display.hyprland.modifier}, SPACE, exec, $menu"
        "ALT, SPACE, exec, qdbus com.coolguy1842.Widgets /Widgets ToggleQuickLauncher"
        "${cfg.display.hyprland.modifier}, P, exec, $picker"
        "${cfg.display.hyprland.modifier}, J, togglesplit,"

        "ALT, left, movefocus, l"
        "ALT, right, movefocus, r"
        "ALT, up, movefocus, u"
        "ALT, down, movefocus, d"

        "${cfg.display.hyprland.modifier}, mouse_down, workspace, m+1"
        "${cfg.display.hyprland.modifier}, mouse_up, workspace, m-1"

        "${cfg.display.hyprland.modifier}, M, fullscreen"
        ",Print, exec, $screenshot"

        "ALT, Tab, cyclenext,"
        "ALT, Tab, bringactivetotop,"
        "ALT SHIFT, Tab, cyclenext, prev"
        "ALT SHIFT, Tab, bringactivetotop,"

        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ]
    ++ (lib.flatten (lib.forEach (getAllWorkspaces cfg.display.hyprland.monitors) (workspace: [
        "${workspace.monitor.workspaceBind}, code:1${toString workspace.index}, workspace, ${toString workspace.id}"
        "${workspace.monitor.workspaceBind} SHIFT, code:1${toString workspace.index}, movetoworkspace, ${toString workspace.id}"
    ])))
    ++ (lib.flatten (lib.mapAttrsToList (name: workspace: ([
        "${workspace.modifier}, ${workspace.keybind}, togglespecialworkspace, ${name}"
        "${workspace.moveModifier}, ${workspace.keybind}, movetoworkspace, special:${name}"
    ])) cfg.display.hyprland.specialWorkspaces));
        
    wayland.windowManager.hyprland.settings.binde = [
        "${cfg.display.hyprland.modifier}, RIGHT, workspace, m+1"
        "${cfg.display.hyprland.modifier}, LEFT, workspace, m-1"
        "${cfg.display.hyprland.modifier} SHIFT, RIGHT, movetoworkspace, e+1"
        "${cfg.display.hyprland.modifier} SHIFT, LEFT, movetoworkspace, e-1"

        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.25"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
    ];

    wayland.windowManager.hyprland.settings.bindm = [
        "${cfg.display.hyprland.modifier}, mouse:272, movewindow"
        "${cfg.display.hyprland.modifier}, mouse:273, resizewindow"
    ];
} 
