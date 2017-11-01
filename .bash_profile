#!/usr/bin/env bash

source "$HOME/.dotfiles/functions/bootstrap.bash"

export DOTFILES_PATH="$HOME/.dotfiles"
export INVISION_PATH="$HOME/projects/invision"
export PLATFORM=$(detectPlatform)
export SHA1_REGEX='^[0-9a-f]{40}$'
export WEBSITES_PATH="$HOME/Websites"

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
if [ -e "$DOTFILES_PATH/git-completion.bash" ]; then
	source "$DOTFILES_PATH/git-completion.bash"
fi

# Include iTerm2 integration
if [ "$PLATFORM" == 'mac' ] && [ -e "$DOTFILES_PATH/.iterm2_shell_integration.bash" ]; then
	source "$DOTFILES_PATH/.iterm2_shell_integration.bash"
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