{ pkgs, unstablePkgs, ... }:

with pkgs; [
  ## unstable
  unstablePkgs.yt-dlp

  ## stable
#   bitwarden-cli
#   # direnv # programs.direnv
#   # docker
  ffmpeg
  git # programs.git
#   ripgrep
#   unzip
#   vim
]
