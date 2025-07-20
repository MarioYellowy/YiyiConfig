{
  description = "Mi configuración de NixOS con flakes";

  inputs = {
    nixpkgs.url      = "github:NixOS/nixpkgs/nixos-25.05";
    hyprland.url     = "github:hyprwm/Hyprland";
    flake-utils.url  = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs         = import nixpkgs { inherit system; config.allowUnfree = true; };
        hmModule     = home-manager.nixosModules.home-manager;
        grubThemeMod = import ./modules/grub/grub-theme.nix { inherit pkgs; };
      in {
        nixosConfigurations = {
          nixos = pkgs.lib.nixosSystem {
            inherit system;
            specialArgs = { inherit self inputs; };

            modules = [
              hmModule
              ./configuration.nix
              grubThemeMod
            ];
          };
        };
      }
    );
}

