{ pkgs, ... }:

let
  grubTheme = pkgs.stdenv.mkDerivation {
    name = "elegant-grub-theme";
    src = ./Elegant-wave-blur-grub-themes/right-dark-1080p_1/Elegant-wave-blur-right-dark;
    installPhase = ''
      mkdir -p $out
      cp -r $src/* $out/
    '';
  };
in {
  environment.etc."grub/themes/Elegant-wave-blur-right-dark".source = ./modules/grub/Elegant-wave-blur-grub-themes/right-dark-1080p_1/Elegant-wave-blur-right-dark;

  boot.loader = {
    systemd-boot.enable = false;

    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";

      theme = "/boot/grub/themes/Elegant-wave-blur-right-dark/theme.txt";

      extraPrepareConfig = ''
        mkdir -p /boot/grub/themes/Elegant-wave-blur-right-dark
        cp -r /etc/grub/themes/Elegant-wave-blur-right-dark/* /boot/grub/themes/Elegant-wave-blur-right-dark/
  '';
    };

    efi.canTouchEfiVariables = false;
  };
}

