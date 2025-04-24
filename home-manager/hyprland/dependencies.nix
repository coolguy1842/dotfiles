{ pkgs, ... }: {
    home.packages = with pkgs; [
        wl-clipboard
        clipman
        hyprpicker
        hyprshade
        playerctl
        wayfreeze
    ];
}