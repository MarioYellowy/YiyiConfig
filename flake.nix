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
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
	  {
            nix.extraOptions = ''
              extra-builtins-file = ${builtins.toFile "extra-builtins.nix" ''
                _: {
                  inherit (builtins) path;
                }
              ''}
            '';
          }
          ./configuration.nix
        ];
	specialArgs = {
          inherit self;
          localFiles = self.outPath;
        };
      };
    };
  };
}
