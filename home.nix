{ config, pkgs, ... }:
{
  home.username = "mario";
  home.homeDirectory = "/home/mario";
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    
  ];

  home.file = {
    ".config/nix/nix.conf".source = ./dotfiles/config/nix/nix.conf;
  };
}
