{ pkgs, cfg, ... }: let 
    createRepeatingBind = name: code: exec: let 
        runDir = "/run/user/1000/mediabinds";

        runScript = pkgs.writeShellScript "run_${name}.sh" ''
            mkdir -p ${runDir}
            if [[ -f ${runDir}/${name} ]]; then
                exit
            fi

            echo $$ > ${runDir}/${name}

            function sigint_exit() {
                rm ${runDir}/${name}
                exit
            }

            trap 'sigint_exit' 2

            while true; do
                ${exec}

                sleep 0.001
            done

            sigint_exit
        '';

        closeScript = pkgs.writeShellScript "close_${name}.sh" ''
            if [[ ! -f ${runDir}/${name} ]]; then
                exit
            fi

            kill -s sigint "$(cat ${runDir}/${name})"
        '';
    in {
        bind = [ ", ${code}, exec, ${runScript}" ];
        bindr = [ ", ${code}, exec, ${closeScript}" ];
    };
in {
    wayland.windowManager.hyprland.settings = let 
        bindsList = [
            (createRepeatingBind "mouseup" "KP_UP" "${pkgs.ydotool}/bin/ydotool mousemove -- 0 -1")
            (createRepeatingBind "mousedown" "KP_BEGIN" "${pkgs.ydotool}/bin/ydotool mousemove -- 0 1")
            (createRepeatingBind "mouseleft" "KP_LEFT" "${pkgs.ydotool}/bin/ydotool mousemove -- -1 0")
            (createRepeatingBind "mouseright" "KP_RIGHT" "${pkgs.ydotool}/bin/ydotool mousemove -- 1 0")
        ];

        bindt = [
            ", KP_HOME, exec, ${pkgs.ydotool}/bin/ydotool click 0x41"
            ", KP_PRIOR, exec, ${pkgs.ydotool}/bin/ydotool click 0x40"
        ] ++ (builtins.concatLists (map (b: b.bind) bindsList));

        bindrt = [
            ", KP_HOME, exec, ${pkgs.ydotool}/bin/ydotool click 0x81"
            ", KP_PRIOR, exec, ${pkgs.ydotool}/bin/ydotool click 0x80"
        ] ++ (builtins.concatLists (map (b: b.bindr) bindsList));
    in {
        inherit bindt bindrt;
    };
}