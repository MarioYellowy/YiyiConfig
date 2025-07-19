{ pkgs, ... }:

let
  grubTheme = ./Elegant-wave-blur-grub-themes/right-dark-1080p_1/Elegant-wave-blur-right-dark;
in {
  environment.etc."grub/themes/Elegant-wave-blur-right-dark".source = grubTheme;

  boot.loader = {
    systemd-boot.enable = false;

    grub = {
      enable                = true;
      efiSupport            = true;
      efiInstallAsRemovable = true;
      device                = "nodev";
      theme                 = "${grubTheme}/theme.txt";
    };

    efi.canTouchEfiVariables = false;
  };
}

