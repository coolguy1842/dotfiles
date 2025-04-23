{ inputs, pkgs, ... }: {
    imports = [
        inputs.ags.homeManagerModules.default
    ];
    
    home.packages = with pkgs; [
        bun
        sassc
    ];

    programs.ags = {
        enable = true;

        configDir = "${toString ../ags}";
        extraPackages = with pkgs; [ accountsservice ];
    };
}