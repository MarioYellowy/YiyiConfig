{ config, pkgs, lib, ... }:

{
  programs.sway.enable = true;

  environment.systemPackages = with pkgs; [
    wl-clipboard-rs
    wtype
  ];

  environment.etc = {
    "sway/config.d/99-custom.conf".text = lib.mkForce ''
      bindsym Control+C exec wl-copy

      # Pegar sin formato con Ctrl+Shift+V
      bindsym Control+Shift+V exec wl-paste | wtype
    '';
  };
}

