#!/usr/bin/env bash

source "$HOME/.dotfiles/functions/bootstrap.bash"

export DOTFILES_BIN_PATH="$HOME/.dotfiles/bin"
export DOTFILES_PATH="$HOME/.dotfiles"
export INVISION_APPLICATION_REPO_ALIASES=(invbo invcc invcnf invd invr invstu invsec invui)
export INVISION_BACKPORT_PATH="$HOME/projects/invision-backport"
export INVISION_DEPENDENCY_REPO_ALIASES=(inva invc inve2e invstc invt invui)
export INVISION_GLOBAL_NPM_MODULES_PATH="$HOME/npm-modules"
export INVISION_PATH="$HOME/projects/invision"
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

# Include shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`
# * ~/.extra can be used for other settings you don’t want to commit
if [ -d "$INVISION_PATH" ]; then
    export DEVELOPMENT_BRANCH_NAME='develop'
    export INVISION_VERSION=${INVISION_VERSIONS[0]}
    export INVISION_VERSION_NPM_CACHE_PATH=${INVISION_VERSION_NPM_CACHE_PATHS[0]}
    export INVISION_VERSION_NPM_MODULES_PATH=${INVISION_VERSION_NPM_MODULES_PATHS[0]}
    export INVISION_VERSION_PATH=${INVISION_VERSION_PATHS[0]}
else
    export DEVELOPMENT_BRANCH_NAME='development'
fi

for file in $DOTFILES_PATH/.{path,bash_prompt,exports,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done

unset file;

# Configure `cd` to autocorrect typos in path names
shopt -s cdspell;

# Configure `history` to keep multi-line commands together, prevent clobbering when closing multiple shells, allow a failed history substitution to be re-edited, and verify expansions before execution
shopt -s cmdhist
shopt -s histappend
shopt -s histreedit
shopt -s histverify

# Configure case-insensitive globbing
shopt -s nocaseglob;

# Check window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null
done

# Create symlink to iCloud Drive from home directory
if [ ! -L "$HOME/iCloud Drive" ]; then
    cd $HOME && ln -s $HOME/Library/Mobile\ Documents/com~apple~CloudDocs "iCloud Drive" && cd -
fi

# Include `fd` integration
if [ -e "$DOTFILES_PATH/integrations/fd-completion.bash" ]; then
    source "$DOTFILES_PATH/integrations/fd-completion.bash"
fi

# Include `fzf` integration
if [ -e "$DOTFILES_PATH/integrations/fzf-completion.bash" ]; then
    source "$DOTFILES_PATH/integrations/fzf-completion.bash"
fi

# Include Git completion
if [ -e "$DOTFILES_PATH/integrations/git-completion.bash" ]; then
    source "$DOTFILES_PATH/integrations/git-completion.bash"
fi

if [ -e "$DOTFILES_PATH/integrations/git-prompt.sh" ]; then
    source "$DOTFILES_PATH/integrations/git-prompt.sh"
fi

# Include iTerm2 integration
if [ "$PLATFORM" == 'mac' ] && [ -e "$DOTFILES_PATH/integrations/.iterm2_shell_integration.bash" ]; then
    source "$DOTFILES_PATH/integrations/.iterm2_shell_integration.bash"
fi

# Use NVM for Node.js version management and include completion
if [ -e "$NVM_DIR" ]; then

    [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
fi

# Enable tab completion for SSH hostnames, while ignoring wildcards
if [ -e "$HOME/.ssh/config" ]; then
    complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh
fi

# Enable Terraform completion
if commandExists terraform; then

    if ! complete -p terraform &> /dev/null; then
        complete -C /usr/local/bin/terraform terraform
    fi
fi

if [ -e "$DOTFILES_PATH/integrations/terraform-prompt.bash" ]; then
    source "$DOTFILES_PATH/integrations/terraform-prompt.bash"
fi

# Include `tldr` integration and completion
TLDR_PATH="$DOTFILES_BIN_PATH/tldr"

if [ -e "$DOTFILES_PATH/integrations/tldr-integration.bash" ] && [ ! -x "$TLDR_PATH" ]; then
    cp "$DOTFILES_PATH/integrations/tldr-integration.bash" "$TLDR_PATH" && chmod +x "$TLDR_PATH"
fi

# Ensure third-party scripts in the bin/ directory are executable
find $DOTFILES_BIN_PATH -path ./man -prune -o -not -name ".gitignore" -print0 | xargs -0 chmod 755

init