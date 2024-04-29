{ pkgs, ... }:
{
  # Use zsh as the default shell. Additional config below.
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [
    bashInteractive
    # sh # already included by default
    zsh
  ];

  programs.bash = {
    enableCompletion = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    # See https://linux.die.net/man/1/zshoptions
    setOptions = [
      "AUTO_CD" # Allow omitting `cd` when trying to change directories
      "AUTO_PUSHD" # `cd` is silently replaced with `pushd`
      "EXTENDED_HISTORY" # Save timestamp with each history entry

      # nixOS Defaults
      "HIST_IGNORE_DUPS" # Don't save a history entry if it's already in the history file
      "SHARE_HISTORY" # Write each shell's history to the file when it exits
      # ^ Replace with INC_APPEND_HISTORY to write each line immediately instead
      "HIST_FCNTL_LOCK" # Improves performance when writing to history
    ];
    histFile = "$HOME/.zsh_history";
    histSize = 10000;
    # initExtra = builtins.readFile(../../../aliases.zsh);

    ohMyZsh = {
      enable = true;
      plugins = [
          "git"
          "z"
      ];
      # custom = "${pkgs.nur.repos.izorkin.oh-my-zsh-custom}"; 
      # theme = "go-cats";
    };

    # interactiveShellInit = ''
    #   source "${pkgs.grc}/etc/grc.zsh"
    # '';
  };
}