{ config, pkgs, ... }:

{
  # 1. Importa la configuración de hardware que generaste
  imports = [
    ./hardware-configuration.nix
  ];

  system.stateVersion = "25.05";

  virtualisation.docker.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = ["acpi_backlight=vendor"
  		       "amdgpu.backlight=0"];

  # 2. Nombre de host (debe coincidir con el atributo en tu flake.nix)
  networking.hostName = "nixos";

  # 3. Locales y zona horaria
  i18n.defaultLocale = "es_MX.UTF-8";
  time.timeZone = "America/Mexico_City";

  # 4. Habilitar servicios básicos
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

      "sddm/themes/catppuccin-mocha/theme.conf".source =
    ./themes/catppuccin-mocha/theme.conf;

      "sddm/themes/catppuccin-mocha/Main.qml".source =
    ./themes/catppuccin-mocha/Main.qml;

      "sddm/themes/catppuccin-mocha/backgrounds/BackgroundZeldaLogin.png".source =
    ./themes/catppuccin-mocha/backgrounds/BackgroundZeldaLogin.png;
  };
  
  services.xserver.enable = true;

  services.xserver.displayManager.sddm = {
    enable = true;
    theme  = "catppuccin-mocha";
  };

  services.displayManager.sddm.package = pkgs.kdePackages.sddm;
  services.displayManager.defaultSession = "hyprland";

  hardware.acpilight.enable = true;

  # 5. Permitir software no libre (heredado de tu flake)
  nixpkgs.config.allowUnfree = true;

  programs.hyprland.enable = true;
  programs.steam.enable = true;

  # 6. Paquetes del sistema (igual que en tu flake)
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
    catppuccin-sddm
    kdePackages.sddm
  ];

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

  environment.variables = {
    XCURSOR_THEME = "Polarnight-cursors";
    XCURSOR_SIZE  = "24";
  };



  services.greetd = {
    settings.default_session = {
      command = "Hyprland";
      user = "mario";
    };
  };

  # 7. Usuarios
  users.users.mario = {
    isNormalUser = true;
    extraGroups  = [ "wheel" "networkmanager" "docker" ];
    shell        = pkgs.nushell;
  };

  # 8. Firewall
  networking.firewall.enable           = true;
  networking.firewall.allowedTCPPorts  = [ 22 80 443 ];

  # 9. Cualquier otro módulo personalizado
  # imports = [ ./otro-modulo.nix ];
}
