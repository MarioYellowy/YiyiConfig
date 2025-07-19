{ config, pkgs, self, ... }:

let
  # Ruta absoluta al tema usando self.outPath
  themeSource = "${self.outPath}/themes/sddm-astronaut-theme";
  
  myMajoraTheme = pkgs.stdenv.mkDerivation {
    name = "my-majora-theme";
    
    # No necesitamos src, usamos rutas directas
    buildInputs = [ pkgs.rsync ];
    
    installPhase = ''
      mkdir -p $out/share/sddm/themes/astronaut
      
      # Copiar estructura completa del tema
      rsync -a ${themeSource}/ $out/share/sddm/themes/astronaut/
    '';
  };
in
{
  nixpkgs.config.allowUnfree = true;
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.05";

  virtualisation.docker.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
  
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    theme  = "my-majora-theme";
    extraPackages = with pkgs.qt6; [ qtmultimedia ];
  };

  services.displayManager.defaultSession = "hyprland";

  hardware.acpilight.enable = true;

  programs.hyprland.enable = true;
  programs.steam.enable = true;

  # Paquetes del sistema
  environment.systemPackages = with pkgs; [
    brave
    nushell
    discord
    youtube-music
    zed-editor
    hyprland
    waybar
    kitty
    wofi
    brightnessctl
    pavucontrol
    networkmanagerapplet
    neovim
    yazi
    git
    prismlauncher
    swaynotificationcenter
    hyprlock
    hypridle
    hyprpaper
    hyprcursor
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
    pulseaudioFull
    playerctl
    dotnetCorePackages.sdk_9_0_3xx
    htop
    jetbrains.rider
    jetbrains.idea-ultimate
    kdePackages.qt6ct
    kdePackages.qtmultimedia
    myMajoraTheme
    gcc
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

  # HyprCursor
  environment.variables = {
    XCURSOR_THEME = "Polarnight-cursors";
    XCURSOR_SIZE  = "24";
  };

  # Usuarios
  users.users.mario = {
    isNormalUser = true;
    extraGroups  = [ "wheel" "networkmanager" "docker" ];
    shell        = pkgs.nushell;
  };

  # Firewall
  networking.firewall.enable           = true;
  networking.firewall.allowedTCPPorts  = [ 22 80 443 ];
}
