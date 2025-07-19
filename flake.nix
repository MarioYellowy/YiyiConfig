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
    grubThemeModule = import ./modules/grub/grub-theme.nix { inherit pkgs; };
    hm = home-manager;
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
	specialArgs = { inherit self inputs; };
        modules = [
          ./configuration.nix
	  grubThemeModule
	  hm.nixosModules.home-manager
	];
      };
    };
    homeConfigurations = {
      mario = hm.lib.homeManagerConfiguration {
        inherit pkgs;
        home.username = "mario";
        home.homeDirectory = "/home/mario";
        modules = [ ./home.nix ];
      };
    };
  };
}

