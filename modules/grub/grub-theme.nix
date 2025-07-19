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
  environment.etc."grub/themes/elegant".source = grubTheme;

  boot.loader = {
    systemd-boot.enable = false;

    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";

      theme = "/boot/grub/themes/elegant/theme.txt";

      extraPrepareConfig = ''
        mkdir -p /boot/grub/themes/elegant
        cp -r /etc/grub/themes/elegant/* /boot/grub/themes/elegant/
      '';
    };

    efi.canTouchEfiVariables = false;
  };
}

