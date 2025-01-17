{
  description = "System configuration flake";

  inputs = {
    # nixpkgs.url = "nixpkgs/nixos-23.05";
    # nixpkgs.url = "nixpkgs/nixos-23.11";
    # nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs.url = "nixpkgs/nixos-24.11";

    nixpkgs-24-05.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    # Framework specific hardware tweaks
    # From https://github.com/NixOS/nixos-hardware/tree/master/framework
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # # Use home manager
    # home-manager.url = "github:nix-community/home-manager"; # targets unstable by default
    # home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # erosanix.url = "github:emmanuelrosa/erosanix";
  };

  outputs = {
    nixpkgs,
    nixpkgs-24-05,
    nixpkgs-unstable,
    nixos-hardware,
    # home-manager,
    # erosanix,
    ...
  }:
  let
    system = "x86_64-linux";

    # pkgs = import nixpkgs {
    #   inherit system;
    #   config = {
    #     # Required by github-desktop
    #     permittedInsecurePackages = [
    #       "openssl-1.1.1w"
    #     ];
    #     # Doesn't seem to be working...
    #     allowUnfree = true;
    #   };
    #   # overlays = [ overlay1 overlay2 ];
    # };

    lib = nixpkgs.lib;

  in {
    nixosConfigurations = {
      f16 = lib.nixosSystem {
        inherit system;
        modules = [
          nixos-hardware.nixosModules.framework-16-7040-amd
          ./modules/configuration.nix
          # ./modules/protonvpn.nix
          {
            nixpkgs.overlays = [
              (final: prev: {
                unstable = import nixpkgs-unstable {
                  inherit system;
                  config.allowUnfree = true;
                };
              })
              (final: prev: {
                pkgs-24-05 = import nixpkgs-24-05 {
                  inherit system;
                  config.allowUnfree = true;
                };
              })
            ];
          }

          # home-manager.nixosModules.home-manager
          # {
          #   home-manager.useGlobalPkgs = true;
          #   home-manager.useUserPackages = true;
          #   home-manager.users.cburton = import ./modules/home.nix;

          #   # Optionally, use home-manager.extraSpecialArgs to pass
          #   # arguments to home.nix
          # }

          # # Facade for Wireguard's "quick" for easily connecting to Proton VPN
          # erosanix.nixosModules.protonvpn
        ];
      };
    };
  };
}
