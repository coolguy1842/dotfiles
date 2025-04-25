{ pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        vscode
        firefox
    ];
}
