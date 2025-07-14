{ confit, pkgs, ... }:

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
  services.xserver.enable = true;
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
    grim
    slurp
    swappy
    surrealist
    teams-for-linux
    stow
    starship
    nwg-look
    catppuccin-gtk
    gimp
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
