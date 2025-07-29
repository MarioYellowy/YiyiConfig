{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/hyprland/hyprland.nix
    ./modules/waybar/waybar.nix
    ./modules/grub/grub-theme.nix
  ];

  virtualisation.docker.enable = true;

  networking = {
    hostName = "nixos";
    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 80 443 ];
    };
  };

  i18n = {
    defaultLocale = "es_MX.UTF-8";
    supportedLocales = [ "en_US.UTF-8/UTF-8" "es_MX.UTF-8/UTF-8" ];
  };

  time.timeZone = "America/Mexico_City";

  services = {
    openssh.enable = true;

    displayManager = {
      sddm.enable = true;
      sddm.wayland.enable = true;
      defaultSession = "hyprland";
    };
  };

  environment.systemPackages = with pkgs; [
    brave
    nushell
    discord
    youtube-music
    zed-editor
    kitty
    pavucontrol
    networkmanagerapplet
    neovim
    yazi
    git
    prismlauncher
    swaynotificationcenter
    xcur2png
    grim
    gimp
    slurp
    swappy
    surrealist
    teams-for-linux
    stow
    starship
    nwg-look
    catppuccin-gtk
    obs-studio
    libreoffice
    unzip
    neofetch
    dotnetCorePackages.sdk_9_0_3xx
    htop
    jetbrains.rider
    jetbrains.idea-ultimate
    kdePackages.qt6ct
    kdePackages.qtmultimedia
    gcc
    tree
    obsidian
    rustup
    fontconfig
  ];

  environment.etc."xdg/wayland-sessions/hyprland.desktop".text = ''
    [Desktop Entry]
    Name=Hyprland
    Comment=Dynamic tiling Wayland compositor
    Exec=Hyprland
    Type=Application
    DesktopNames=Hyprland
  '';

  fonts = {
    fontDir.enable = true;
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      font-awesome
    ];
  };

  hardware.acpilight.enable = true;

  programs.steam.enable = true;

  users.users.mario = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.nushell;
  };

  home-manager.users.mario = import ./home.nix {
    inherit config pkgs inputs;
  };
}

