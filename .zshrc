#!/usr/bin/env zsh

source "$HOME/.dotfiles/functions/bootstrap.sh"

export DOTFILES_BIN_PATH="$HOME/.dotfiles/bin"
export DOTFILES_PATH="$HOME/.dotfiles"
export INVISION_APPLICATION_REPO_ALIASES=(invbo invcc invcnf invd invr invstu invsec invui)
export INVISION_BACKPORT_PATH="$HOME/projects/invision-backport"
export INVISION_DEPENDENCY_REPO_ALIASES=(inva invc inve2e invstc invt invui)
export INVISION_GLOBAL_NPM_MODULES_PATH="$HOME/npm-modules"
export INVISION_PATH="$HOME/projects/invision"
export INVISION_REACT_PATH="$HOME/projects/invision-react"
export INVISION_REPO_ALIASES=("${INVISION_DEPENDENCY_REPO_ALIASES[@]}" "${INVISION_APPLICATION_REPO_ALIASES[@]}" "${INVISION_STARTER_ALIAS}")
export INVISION_STARTER_ALIAS='invstr'
export INVISION_VERSION_NPM_CACHE_PATHS=("${INVISION_PATH}/npm-cache" "${INVISION_BACKPORT_PATH}/npm-cache")
export INVISION_VERSION_NPM_MODULES_PATHS=("${INVISION_PATH}/npm-modules" "${INVISION_BACKPORT_PATH}/npm-modules")
export INVISION_VERSION_PATHS=($INVISION_PATH $INVISION_BACKPORT_PATH)
export INVISION_VERSIONS=('invision' 'invision-backport')
export SELFCARE_PATH="$HOME/projects/selfcare"
export SELFCARE_REPO_ALIASES=(slf slfc slfui)

export PLATFORM=$(detectPlatform)
export RELATIVE_COMMIT_REGEX='^[0-9]+$'
export SHA1_REGEX='^[0-9a-f]{40}$'

export ZSH="$DOTFILES_PATH/.oh-my-zsh"
ZSH_THEME=""
# ENABLE_CORRECTION="true"

plugins=(
    aws
    history
)

source $ZSH/oh-my-zsh.sh

# Include shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`
# * ~/.extra can be used for other settings you don’t want to commit
if [[ -d "$INVISION_PATH" ]]; then
    export DEVELOPMENT_BRANCH_NAME='develop'
    export INVISION_VERSION=${INVISION_VERSIONS[1]}
    export INVISION_VERSION_NPM_CACHE_PATH=${INVISION_VERSION_NPM_CACHE_PATHS[1]}
    export INVISION_VERSION_NPM_MODULES_PATH=${INVISION_VERSION_NPM_MODULES_PATHS[1]}
    export INVISION_VERSION_PATH=${INVISION_VERSION_PATHS[1]}
else
    export DEVELOPMENT_BRANCH_NAME='development'
fi

for file in $DOTFILES_PATH/.{path,bash_prompt,exports,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done

unset file;

# Configure `cd` to autocorrect typos in path names
# shopt -s cdspell;

# Configure `history` to keep multi-line commands together, prevent clobbering when closing multiple shells, allow a failed history substitution to be re-edited, and verify expansions before execution
# shopt -s cmdhist
# shopt -s histappend
# shopt -s histreedit
# shopt -s histverify

# Configure case-insensitive globbing
# shopt -s nocaseglob;

# Check window size after each command and, if necessary, update the values of LINES and COLUMNS
# shopt -s checkwinsize

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null
done

# Create symlink to Git configuration
if commandExists git && [ ! -L $HOME/.gitconfig ]; then
    cd $HOME && ln -s "$DOTFILES_PATH/.gitconfig" "$HOME/.gitconfig" && cd -
fi

# Create symlink to iCloud Drive from home directory
if [ ! -L "$HOME/iCloud Drive" ]; then
    cd $HOME && ln -s $HOME/Library/Mobile\ Documents/com~apple~CloudDocs "iCloud Drive" && cd -
fi

# Include `fd` integration
# if [ -e "$DOTFILES_PATH/integrations/fd-completion.sh" ]; then
#     source "$DOTFILES_PATH/integrations/fd-completion.sh"
# fi

# Include `fzf` integration
# if [ -e "$DOTFILES_PATH/integrations/fzf-completion.sh" ]; then
#     source "$DOTFILES_PATH/integrations/fzf-completion.sh"
# fi

# Include 1Password completion
eval "$(op completion zsh)";
compdef _op op

# Include Git completion
zstyle ':completion:*:*:git:*' script "$DOTFILES_PATH/integrations/git-completion.bash"
fpath=("$DOTFILES_PATH/integrations" $fpath)

autoload -Uz compinit && compinit

# if [ -e "$DOTFILES_PATH/integrations/git-completion.zsh" ]; then
#     source "$DOTFILES_PATH/integrations/git-completion.zsh"
# fi

if [ -e "$DOTFILES_PATH/integrations/git-prompt.sh" ]; then
    source "$DOTFILES_PATH/integrations/git-prompt.sh"
fi

# Include iTerm2 integration
source "$DOTFILES_PATH/integrations/.iterm2_shell_integration.zsh"

# Use NVM for Node.js version management and include completion
if [ -e "$NVM_DIR" ]; then

    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
fi

# Create symlink to Okta-AWSCLI (https://github.com/jmhale/okta-awscli) configuration
if commandExists okta-awscli && [ ! -L "$HOME/.okta-aws" ]; then
    cd $HOME && ln -s "$DOTFILES_PATH/.okta-aws" "$HOME/.okta-aws" && cd -
fi

# Enable tab completion for SSH hostnames, while ignoring wildcards
if [ -e "$HOME/.ssh/config" ]; then
    complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh
fi

# Enable Terraform completion and prompt
if commandExists terraform; then

    if ! complete -p terraform &> /dev/null; then
        complete -o nospace -C /usr/local/bin/terraform terraform
    fi
fi

if [ -e "$DOTFILES_PATH/integrations/terraform-prompt.sh" ]; then
    source "$DOTFILES_PATH/integrations/terraform-prompt.sh"
fi

# Include `tldr` integration and completion
TLDR_PATH="$DOTFILES_BIN_PATH/tldr"

if [ -e "$DOTFILES_PATH/integrations/tldr-integration.sh" ] && [ ! -x "$TLDR_PATH" ]; then
    cp "$DOTFILES_PATH/integrations/tldr-integration.sh" "$TLDR_PATH" && chmod +x "$TLDR_PATH"
fi

# Ensure third-party scripts in the bin/ directory are executable
find $DOTFILES_BIN_PATH -path ./man -prune -o -not -name ".gitignore" -print0 | xargs -0 chmod 755

# Add Python and Yarn to $PATH
if commandExists /usr/bin/python3; then
    export PY_USER_BIN=$(python -c 'import site; print(site.USER_BASE + "/bin")')
fi

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH=$PY_USER_BIN:$PATH

autoload -Uz compinit && compinit

init