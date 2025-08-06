{
  description = "Mi yiyi config de NixOS con flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, unstable, hyprland, home-manager, flake-utils, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { 
      inherit system;
      config.allowUnfree = true;
      allowInsecurePackages = [ "ventoy" ];
    };
    hmModule = home-manager.nixosModules.home-manager;
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
	pkgs = pkgs;
	specialArgs = { inherit self inputs; };
        modules = [
	  hmModule
	  ./modules.nix {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
	  }
	  {
	    system.activationScripts.home-manager.text = ''
              after=("users")
            '';
	  }
          {
            system.stateVersion = "25.05";
          }
	  {
	    hardware.bluetooth.enable = true;
	    hardware.bluetooth.powerOnBoot = false;
	  }
	];
      };
    };
  };
}
