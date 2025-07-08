{
  description = "Mi configuración de NixOS con flakes";

  inputs = {
    nixpkgs.url     = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url    = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url    = "github:hyprwm/Hyprland";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, unstable, hyprland, flake-utils, ... }:
  let
    system = "x86_64-linux";
    pkgs   = import nixpkgs { inherit system; config.allowUnfree = true; };
    pkgsUnstable = import unstable { inherit system; config.allowUnfree = true; };
  in {
    # Ahora está en la raíz de outputs
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
        ];
    };

    # Si quieres seguir usando paquetes genéricos:
    packages = {
      default = pkgs.hello;
    };
  };
};
}
