{ config, pkgs, … }:
{
  home.username = "mario";
  home.homeDirectory = "/home/mario";

  home.packages = with pkgs; [
    
  ];

  home.file = {
    ".config/nix/nix.conf".source = ../dotfiles/nix.conf;
  };
}
