{ config, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    hyprland
    hyprlock
    hypridle
    hyprpaper
    hyprcursor
    wl-clipboard
    wtype
  ];

  # HyprCursor
  environment.variables = {
    XCURSOR_THEME = "Polarnight-cursors";
    XCURSOR_SIZE  = "24";
  };
}

