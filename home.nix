{ config, pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;

  hypr = inputs.hyprland.packages.${system}.hyprland;
  portal = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
in
{
  home.username = "mario";
  home.homeDirectory = "/home/mario";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  systemd.user.startServices = "sd-switch";

  home.packages = with pkgs; [
  ];

  home.file = {
    ".config/nix/nix.conf".source = ./dotfiles/config/nix/nix.conf;
    ".config/waybar/config.jsonc".source = ./dotfiles/config/waybar/config.jsonc;
    ".config/waybar/style.css".source = ./dotfiles/config/waybar/style.css;
  };

  xdg.configFile."hypr/hyprland.conf".source = ./dotfiles/config/hypr/hyprland.conf;
  wayland.windowManager.hyprland = {
    enable = true;
    package = hypr;
    portalPackage = portal;
  };

  programs.nushell = {
    enable = true;
  };
}

