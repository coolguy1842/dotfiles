{ lib, ... }: monitors: let
    list = lib.flatten (lib.mapAttrsToList (name: monitor:
        lib.genList (i: {
            monitor = {
                name = name;
                workspaceBind = monitor.workspaceBind;
                workspaceIDOffset = monitor.workspaceIDOffset;
            };

            name = "${name}|${toString (i + 1)}";
            index = i;
        }) monitor.workspaces
    ) monitors);

    workspaces = lib.genList (i:
        (lib.elemAt list i) // { id = i + 1; }
    ) (lib.length list);
in workspaces