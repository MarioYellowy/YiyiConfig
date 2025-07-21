{ config, pkgs, ...};
{
  environment.systemPackages = with pkgs; [
    waybar
    wofi
    pulseaudioFull
    playerctl
  ]
}
