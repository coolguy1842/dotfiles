{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        librewolf
        chiaki-ng
        vscode
    ];
}
