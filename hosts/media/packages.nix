{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        librewolf
        chiaki
        vscode
    ];
}
