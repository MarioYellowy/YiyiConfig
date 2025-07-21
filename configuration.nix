{ config, pkgs, lib, inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./hardware-configuration.nix
    ./modules/hyprland/hyprland.nix
  ];

  system.stateVersion = "25.05";

  virtualisation.docker.enable = true;

  # Nombre de host
  networking.hostName = "nixos";

  # Locales y zona horaria
  i18n.defaultLocale = "es_MX.UTF-8";
  time.timeZone = "America/Mexico_City";

  # Habilitar servicios básicos
  services.openssh.enable = true;

  environment.etc = {
    "xdg/wayland-sessions/hyprland.desktop".text = ''
      [Desktop Entry]
      Name=Hyprland
      Comment=Dynamic tiling Wayland compositor
      Exec=Hyprland
      Type=Application
      DesktopNames=Hyprland
      '';
  };
  
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  services.displayManager.defaultSession = "hyprland-uwsm";

  hardware.acpilight.enable = true;

  programs.steam.enable = true;

  home-manager.useGlobalPkgs       = true;
  home-manager.useUserPackages     = true;
  home-manager.users.mario = import ./home.nix {
    inherit config pkgs inputs;
  };
  home-manager.backupFileExtension = "bkp";

  # Paquetes del sistema
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
  ];

  #Fonts
  fonts = {
    fontDir.enable    = true;
    fontconfig.enable = true;

    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.hack
      font-awesome
    ];
  };

  # Usuarios
  users.users.mario = {
    isNormalUser = true;
    extraGroups  = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.nushell;
  };

  # Firewall
  networking.firewall.enable           = true;
  networking.firewall.allowedTCPPorts  = [ 22 80 443 ];
}
