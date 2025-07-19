{
  description = "Mi configuración de NixOS con flakes";

  inputs = {
    nixpkgs.url       = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url      = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url      = "github:hyprwm/Hyprland";
    flake-utils.url   = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, unstable, hyprland, flake-utils, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { 
      inherit system; 
      config.allowUnfree = true;
    };
    grubThemeModule = import ./modules/grub/grub-theme.nix { inherit pkgs; };
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
	specialArgs = { inherit self; };
        modules = [
          ./configuration.nix
	  grubThemeModule
	];
      };
    };
  };
}

