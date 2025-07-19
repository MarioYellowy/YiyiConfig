{
  description = "Mi configuración de NixOS con flakes";

  inputs = {
    nixpkgs.url       = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url      = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url      = "github:hyprwm/Hyprland";
    flake-utils.url   = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, unstable, hyprland, flake-utils, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { 
      inherit system; 
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
	specialArgs = { inherit self; };
        modules = [
	  ({ self, ... }: {
            nix.extraOptions = "!include ${./nix-path-conf.nix}";
          })
          ./configuration.nix
        ];
      };
    };
  };
}
