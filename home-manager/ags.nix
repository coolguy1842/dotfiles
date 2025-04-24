{ inputs, pkgs, ... }: {
    imports = [
        inputs.ags.homeManagerModules.default
    ];
    
    home.packages = with pkgs; [
        bun
        sassc
        socat
    ];

    programs.ags = {
        enable = true;

        configDir = "${toString ../ags}";
        extraPackages = with pkgs; [ accountsservice ];
    };
}