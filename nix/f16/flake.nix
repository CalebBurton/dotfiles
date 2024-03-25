{
  description = "System configuration flake";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-23.05";
    # nixpkgs.url = "nixpkgs/nixos-23.11";
    nixpkgs.url = "nixpkgs/nixos-unstable";

    # Use home manager
    # home-manager.url = "github:nix-community/home-manager/release-23.05";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Waiting on https://github.com/NixOS/nixos-hardware/issues/859
    # # Framework specific hardware tweaks
    # # From https://github.com/NixOS/nixos-hardware/tree/master/framework
    # nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = {
    nixpkgs,
    # nixos-hardware,
    ...
  }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = {
        # Required by github-desktop
        permittedInsecurePackages = [
          "openssl-1.1.1w"
        ];
        # Doesn't seem to be working...
        allowUnfree = true;
      };
      # overlays = [ overlay1 overlay2 ];
    };

    lib = nixpkgs.lib;

  in {
    nixosConfigurations = {
      f16 = lib.nixosSystem {
        inherit system;
        modules = [
          # nixos-hardware.nixosModules.framework
          ./configuration.nix
          # ./modules/protonvpn.nix
        ];
      };
    };

  };
}
