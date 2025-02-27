# Symlink this into the home directory: `ln -sf /path/to/this/file ~/.zshrc`

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

POTENTIAL_PATHS=(
  "$HOME/bin"
  "$HOME/.local/bin" # Poetry
  "$HOME/.cargo/bin" # Rustup
  "/usr/local/bin"   # Intel Homebrew?
  "/Applications/Docker.app/Contents/Resources/bin/" # Docker Desktop for Mac
  "/usr/bin"
  "/bin"
  "/usr/sbin"
  "/sbin"
  "/usr/local/munki"
)
for var in "${POTENTIAL_PATHS[@]}"
do
  if [ -e "$var" ]; then
    export PATH="$var:$PATH"
  fi
done


if [[ $(uname -m) == 'arm64' ]]; then
  export IS_M1=1
else
  export IS_M1=0
fi

if [[ "$(uname)" == "Darwin" ]]; then
  export IS_MACOS=1
else
  export IS_MACOS=0
fi

# Add `brew` and homebrew support binaries
if [[ $IS_M1 == 1 ]]; then
  export PATH="/opt/homebrew/bin:$PATH" # M1 directory
else
  export PATH="/usr/local/sbin:$PATH" # Intel directory
fi

# Python version management with pyenv
export PYENV_ROOT="/usr/local/var/pyenv"
if [ -e $PYENV_ROOT ] && command -v pyenv >/dev/null 2>&1; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  # Slows down startup considerably, and isn't strictly necessary.
  # It automatically activates the local pyenv when you cd into a directory
  # eval "$(pyenv virtualenv-init -)"
fi

# Add postgres
export PGDATA="/usr/local/var/postgres"
if [ -e $PGDATA ]; then
  export PATH="/opt/homebrew/opt/postgresql@11/bin:$PATH"
fi

# Used extensively in the aliases file
export GITHUB_DIR="$HOME/Code/GitHub"
export ALEDADE_DIR="$HOME/Code/Aledade"


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

source "$GITHUB_DIR/dotfiles/aliases.zsh" # Store all aliases in their own file

# Allow filtering the arrow up and arrow down buttons to only match commands
# beginning with what is already typed
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A'  up-line-or-beginning-search    # Arrow up
bindkey '^[OA'  up-line-or-beginning-search
bindkey '^[[B'  down-line-or-beginning-search  # Arrow down
bindkey '^[OB'  down-line-or-beginning-search

# Use `vi` key bindings. Make sure this is near the bottom of the config.
bindkey -v # (in bash this would be `set -o vi`)
# avoid the annoying backspace/delete issue
# where backspace stops deleting characters
bindkey -v '^?' backward-delete-char

# Add NVM
# By default this is extremely slow. A workaround was copied from GitHub here:
# https://github.com/nvm-sh/nvm/issues/539#issuecomment-245791291
# The `--no-use` flag makes it load asynchronously.
#
# There's another option that uses the `zsh-async` library, but it seems like
# overkill: https://github.com/nvm-sh/nvm/issues/539#issuecomment-403661578
#
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" --no-use
alias node='unalias node ; unalias npm ; nvm use default ; node $@'
alias npm='unalias node ; unalias npm ; nvm use default ; npm $@'

# Add Aledade-specific config
if command -v scutil &> /dev/null && \
   [ "$(scutil --get ComputerName)" = "Aledade-M3680" ]; then
  # pyenv-virtualenv could do this too, but it's soooo slow
  pyenv_dirs=("outreach" "ingestion-biz-logic" "dbt" "aledade.models")
  for item in "${pyenv_dirs[@]}"; do
    if [[ "$item" == $(basename $(pwd)) ]] && \
       command -v pyenv >/dev/null 2>&1; then
      pyenv activate
      break
    fi
  done
fi

# =============================================================================
# Nix
# =============================================================================
# # Add nix, if installed
# if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ] ; then
#   . "$HOME/.nix-profile/etc/profile.d/nix.sh"
# fi

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# nix-darwin
# I'm sure there's a better way to do this, but whatever.
if [ -e '/nix/store/zgz87qspyip4ls6srcm0qkxj4kzj0rkw-set-environment' ]; then
  . '/nix/store/zgz87qspyip4ls6srcm0qkxj4kzj0rkw-set-environment'
fi
# =============================================================================

# Add direnv:
#  When cd'ing into a directory with a .envrc, automatically loads it
if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
fi

# Enable iterm's shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
