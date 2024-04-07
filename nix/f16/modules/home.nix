{pkgs, ...}: {
    # useGlobalPkgs = true;
    # useUserPackages = true;
    home.username = "cburton";
    home.homeDirectory = "/home/cburton";
    home.packages = with pkgs; [
        # nixpkgs-fmt
        cowsay
    ];

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager
    # release introduces backwards incompatible changes.
    home.stateVersion = "24.05";
    # home.stateVersion = ""; # Uncomment this line to see available options

    # Let Home Manager install and manage itself.
    programs.home-manager.enable = true;
}