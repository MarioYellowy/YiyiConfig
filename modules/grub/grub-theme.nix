{ pkgs, ... }:

let
  grubTheme = pkgs.runCommand "grub-theme-elegant" {
    src = ./Elegant-wave-blur-grub-themes/right-dark-1080p_1/Elegant-wave-blur-right-dark;
  } ''
    mkdir -p $out
    cp -r $src/* $out/
  '';
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
    };
    efi.canTouchEfiVariables = false;
  };
}

