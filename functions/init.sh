#!/usr/bin/env zsh

# Define custom function to initialize environment

init() {

    # Configure screenshots
    local SCREENSHOTS_PATH=$HOME/Temp/screenshots

    if [ ! -d "$SCREENSHOTS_PATH" ]; then
        mkdir "$SCREENSHOTS_PATH"
    fi

    defaults write com.apple.screencapture location SCREENSHOTS_PATH && \
        defaults write com.apple.screencapture disable-shadow true && \
        killall SystemUIServer

    # Configure Dock
    defaults write com.apple.dock mineffect -string scale && \
        killall Dock

    # Enable QuickLook plugins
    if [ ! -d "$HOME/Library/QuickLook" ]; then
        mkdir "$HOME/Library/QuickLook"
    fi

    find "$DOTFILES_PATH/miscellaneous/quicklook_plugins" -depth 1 -type d -exec ln -fs {} "$HOME/Library/QuickLook" ';' &&
        qlmanage -r
}