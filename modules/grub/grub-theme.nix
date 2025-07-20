{ pkgs, ... }:

{
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
      theme = pkgs.stdenv.mkDerivation {
        pname = "elegant-grub-theme";
        version = "1.0";
        src = ./Elegant-wave-blur-grub-themes/right-dark-1080p_1/Elegant-wave-blur-right-dark;
        installPhase = ''
          mkdir -p $out
          cp -r ./* $out/
        '';
      };
    };
    efi = {
      canTouchEfiVariables = false;
    };
  };
}

