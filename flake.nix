{
  description = "Mi configuración de NixOS con flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
  };

  outputs = inputs@{ self, nixpkgs, unstable, hyprland, home-manager, flake-utils, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { 
      inherit system; 
      config.allowUnfree = true;
    };
    hmModule = home-manager.nixosModules.home-manager;
    grubThemeModule = import ./modules/grub/grub-theme.nix { inherit pkgs; };
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
	specialArgs = { inherit self inputs; };
        modules = [
	  hmModule
          ./configuration.nix
	  {
            programs.hyprland = {
              enable = true;
              package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
              portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
              xwayland.enable = true;
	      withUWSM = true;
            };
          }
	  grubThemeModule
	];
      };
    };
  };
}
