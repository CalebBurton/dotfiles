# Symlink this into the home directory: `ln -sf /path/to/this/file ~/.zshrc`

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See below for more PATH changes
export PATH="$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/munki"

# Add `brew` and homebrew support binaries
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# Add rustup
export PATH="$HOME/.cargo/bin:$PATH"

# Add postgres config
export PGDATA="/usr/local/var/postgres"


# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="go-cats"

# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.

# git is a built-in plugin (I think)
# zsh-syntax-highlighting is from https://github.com/zsh-users/zsh-syntax-highlighting/
# zsh-autosuggestions is from https://github.com/zsh-users/zsh-autosuggestions/
# ^^^^^^^^^^^^ make sure these are installed in the proper folder:
    # git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    # git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  z
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

source $HOME/Documents/GitHub/dotfiles/aliases.zsh # Store all aliases in their own file

# Allow filtering the arrow up and arrow down buttons to only match commands beginning with what is already typed
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A'  up-line-or-beginning-search    # Arrow up
bindkey '^[OA'  up-line-or-beginning-search
bindkey '^[[B'  down-line-or-beginning-search  # Arrow down
bindkey '^[OB'  down-line-or-beginning-search

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Move next only if `homebrew` is installed
if command -v brew >/dev/null 2>&1; then
  # Load rupa's z if installed
  [ -f $(brew --prefix)/etc/profile.d/z.sh ] && source $(brew --prefix)/etc/profile.d/z.sh
fi

# # Install the "trash-cli" npm package to make "rm" safer
# TRASH_CLI=$(command -v trash)
# if ! [ -x "$TRASH_CLI" ]; then
#     echo "Trash-CLI npm package not found. Installing globally..." >&2
#     # If this fails, try fixing the global npm permissions with
#     # `sudo chown -R $USER /usr/local/lib/node_modules`
#     npm install --global trash-cli
# fi

# # Add all local ssh keys to the ssh agent (SUPER SLOW!)
# if [ -z "$SSH_AUTH_SOCK" ] ; then
#   eval `ssh-agent -s` &> /dev/null
#   find "$HOME/.ssh" -type f -iname "id_*" ! -iname "*.pub" | \
#   while read line; do ssh-add $line &> /dev/null ; done
# fi

# Add CIQ-specific pieces
if [ "$(scutil --get ComputerName)" = "CB Work MacBook" ]; then

  # Add nix, if installed
  if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] ; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  fi

  # Add direnv:
  #  When cd'ing into a directory with a .envrc, automatically calls nix-shell
  if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
  fi

  # Add gcloud sdk, if installed
  if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ] ; then
    . "$HOME/google-cloud-sdk/path.zsh.inc"
  fi

  # Enable shell completion for gcloud sdk
  if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ] ; then
    . "$HOME/google-cloud-sdk/completion.zsh.inc"
  fi
fi

# Enable iterm's shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
