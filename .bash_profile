#!/usr/bin/env bash

source "$HOME/.dotfiles/functions/bootstrap.bash"

export DOTFILES_BIN_PATH="$HOME/.dotfiles/bin"
export DOTFILES_PATH="$HOME/.dotfiles"
export INVISION_PATH="$HOME/projects/invision"
export INVISION_REPO_ALIASES=(invc invui invbo invcc invcnf invd invr invsta invstu invsec inv inve2e)
export PLATFORM=$(detectPlatform)
export SHA1_REGEX='^[0-9a-f]{40}$'

# Include shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`
# * ~/.extra can be used for other settings you don’t want to commit
if [ -d "$INVISION_PATH" ]; then
    export DEVELOPMENT_BRANCH_NAME='develop'
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

# Include TL;DR integration and completion
TLDR_PATH="$DOTFILES_BIN_PATH/tldr"

if [ -e "$DOTFILES_PATH/integrations/tldr-integration.bash" ] && [ ! -x "$TLDR_PATH" ]; then
    cp "$DOTFILES_PATH/integrations/tldr-integration.bash" "$TLDR_PATH" && chmod +x "$TLDR_PATH"
fi