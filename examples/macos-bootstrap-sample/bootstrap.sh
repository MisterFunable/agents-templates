#!/bin/bash

# Fail immediately on any errors
set -e
set -u

# Trap errors with helpful messages
trap 'echo "❌ Error on line $LINENO. Exit code: $?"' ERR

echo "🚀 Starting macOS bootstrap script..."
echo "=================================="

# Zsh Installation
if ! command -v zsh >/dev/null 2>&1; then
    echo "Installing Zsh..."
    # Replace with your package manager's install command if not using apt
    sudo apt install zsh
    echo "Zsh installed successfully."
else
    echo "Zsh already installed."
fi

# Oh My Zsh Installation
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "Oh My Zsh installed successfully."
else
    echo "Oh My Zsh already installed."
fi

# Homebrew Installation
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed."
fi

# ZSH Plugin Installation
ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

install_zsh_plugin() {
    local url="$1"
    local dir="$ZSH_CUSTOM_DIR/plugins/$(basename "$url" .git)"

    if [ ! -d "$dir" ]; then
        echo "Cloning $url..."
        git clone "$url" "$dir"
    else
        echo "Plugin $(basename "$url") already installed."
    fi
}

install_zsh_plugin https://github.com/zsh-users/zsh-syntax-highlighting.git
install_zsh_plugin https://github.com/zsh-users/zsh-autosuggestions.git

# MacOS
echo "Keyboard and mouse configurations"
defaults write -g InitialKeyRepeat -int 35
defaults write -g KeyRepeat -int 2
defaults write -g com.apple.mouse.scaling 2.0
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode TwoButton

echo "Spanish because Ñ"
defaults read -g AppleLanguages
defaults write -g AppleLanguages -array "es-ES"

echo "Who even uses this?"
defaults delete com.apple.dock
defaults write com.apple.dock static-only -bool true
defaults write com.apple.dock show-recents -bool true

killall Dock

# echo "Computer name"
# sudo scutil --set HostName basic
# sudo scutil --set LocalHostName basic
# sudo scutil --set ComputerName basic # What you see in the Terminal
# dscacheutil -flushcache

# Detect the primary system language
LANGUAGE=$(defaults read -g AppleLanguages | head -2 | tail -1 | tr -d ' ",')
echo "Detected language: $LANGUAGE"

if [[ "$LANGUAGE" == es* ]]; then
  echo "Setting Spotlight order for Spanish..."
  defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 1;"name" = "APLICACIONES";}' \
    '{"enabled" = 1;"name" = "MENU_DEFINITION";}' \
    '{"enabled" = 1;"name" = "DOCUMENTOS";}' \
    '{"enabled" = 1;"name" = "DIRECTORIOS";}' \
    '{"enabled" = 0;"name" = "FUENTES";}' \
    '{"enabled" = 0;"name" = "MENSAJES";}' \
    '{"enabled" = 0;"name" = "CONTACTOS";}' \
    '{"enabled" = 0;"name" = "EVENTOS_Y_TAREAS";}' \
    '{"enabled" = 0;"name" = "IMÁGENES";}' \
    '{"enabled" = 0;"name" = "MARCADORES";}' \
    '{"enabled" = 0;"name" = "MÚSICA";}' \
    '{"enabled" = 0;"name" = "PELÍCULAS";}' \
    '{"enabled" = 0;"name" = "PRESENTACIONES";}' \
    '{"enabled" = 0;"name" = "HOJAS_DE_CÁLCULO";}' \
    '{"enabled" = 0;"name" = "CÓDIGO_FUENTE";}' \
    '{"enabled" = 0;"name" = "PDF";}' \
    '{"enabled" = 0;"name" = "PREFERENCIAS_DEL_SISTEMA";}'
else
  echo "Setting Spotlight order for English..."
  defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 1;"name" = "APPLICATIONS";}' \
    '{"enabled" = 1;"name" = "MENU_DEFINITION";}' \
    '{"enabled" = 1;"name" = "DOCUMENTS";}' \
    '{"enabled" = 1;"name" = "DIRECTORIES";}' \
    '{"enabled" = 0;"name" = "FONTS";}' \
    '{"enabled" = 0;"name" = "MESSAGES";}' \
    '{"enabled" = 0;"name" = "CONTACT";}' \
    '{"enabled" = 0;"name" = "EVENT_TODO";}' \
    '{"enabled" = 0;"name" = "IMAGES";}' \
    '{"enabled" = 0;"name" = "BOOKMARKS";}' \
    '{"enabled" = 0;"name" = "MUSIC";}' \
    '{"enabled" = 0;"name" = "MOVIES";}' \
    '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
    '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
    '{"enabled" = 0;"name" = "SOURCE";}' \
    '{"enabled" = 0;"name" = "PDF";}' \
    '{"enabled" = 0;"name" = "SYSTEM_PREFS";}'
fi

# Rebuild Spotlight index
echo "Rebuilding Spotlight index..."
sudo mdutil -E / 2>/dev/null || echo "Note: Spotlight rebuild requires admin privileges"

# Index Downloads folder specifically
mdimport ~/Downloads 2>/dev/null || echo "Note: Downloads folder indexing attempted"

# Downloads Folder in Dock (Fan View, Sorted by Date Created)
echo "Configuring Downloads folder in Dock..."

# Add Downloads folder to Dock with fan view and date sorting
defaults write com.apple.dock persistent-others -array-add "
  <dict>
    <key>tile-data</key>
    <dict>
      <key>file-data</key>
      <dict>
        <key>_CFURLString</key>
        <string>file://$HOME/Downloads/</string>
        <key>_CFURLStringType</key>
        <integer>15</integer>
      </dict>
      <key>arrangement</key>
      <integer>4</integer>
      <key>displayas</key>
      <integer>1</integer>
      <key>showas</key>
      <integer>1</integer>
    </dict>
    <key>tile-type</key>
    <string>directory-tile</string>
  </dict>
"

# Note: arrangement values: 1=Name, 2=Date Added, 3=Date Modified, 4=Date Created, 5=Kind
# showas values: 0=Automatic, 1=Fan, 2=Grid, 3=List
# displayas values: 0=Stack, 1=Folder

echo "✅ Downloads folder configured in Dock"

# Finder Configuration
echo "Configuring Finder preferences..."

# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Disable warning when changing file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disable .DS_Store files on network and USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Keep folders on top when sorting
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Default to list view
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Search current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

killall Finder 2>/dev/null || echo "Finder will restart on next login"

echo "✅ Finder configured"

# Security Settings
echo "Configuring security settings..."

# Enable Gatekeeper (allows App Store and identified developers)
sudo spctl --master-enable 2>/dev/null || echo "Note: Gatekeeper configuration requires admin privileges"

# Enable firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on 2>/dev/null || echo "Note: Firewall configuration requires admin privileges"

# Enable stealth mode
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on 2>/dev/null || true

# Disable remote Apple events
sudo systemsetup -setremoteappleevents off 2>/dev/null || true

# Disable wake on network access
sudo systemsetup -setwakeonnetworkaccess off 2>/dev/null || true

# Require password immediately after sleep or screen saver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Disable guest user
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false 2>/dev/null || true

# Enable secure keyboard entry in Terminal
defaults write com.apple.terminal SecureKeyboardEntry -bool true

echo "✅ Security settings configured"

# Safari HTTPS Enforcement
echo "Configuring Safari security..."

# Upgrade to HTTPS automatically
defaults write com.apple.Safari \
  com.apple.Safari.ContentPageGroupIdentifier.WebKit2UpgradeKnownHostsToHTTPS -bool true

# Warn about fraudulent websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Block pop-ups
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari \
  com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

# Enable "Do Not Track"
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

echo "✅ Safari configured for HTTPS enforcement"

# Developer & Creative Professional Settings
echo "Configuring developer and creative settings..."

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Enable full keyboard access for all controls
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Disable smart quotes and dashes (useful for coding)
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Terminal: Use Pro theme
defaults write com.apple.terminal "Default Window Settings" -string "Pro"
defaults write com.apple.terminal "Startup Window Settings" -string "Pro"

# Show battery percentage
defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Enable text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

echo "✅ Developer and creative settings configured"

# ASDF Plugin Installation
echo "Installing ASDF plugins"

install_asdf_plugin() {
    local name="$1"
    local url="$2"
    shift 2

    echo "Checking plugin: $name"
    if ! asdf plugin-list | grep -q "^$name$"; then
        echo "Installing $name plugin from $url"
        asdf plugin add "$name" "$url"
    else
        echo "$name plugin already installed."
    fi

    local all_versions_installed=true
    for version in "$@"; do
        if ! asdf list "$name" | grep -q "^  $version$"; then
            all_versions_installed=false
            break
        fi
    done

    if [ "$all_versions_installed" = true ]; then
        echo "All requested $name versions already installed."
    else
        for version in "$@"; do
            if ! asdf list "$name" | grep -q "^  $version$"; then
                echo "Installing $name version $version"
                asdf install "$name" "$version"
            else
                echo "$name version $version already installed."
            fi
        done
    fi

    local last_version="${@: -1}"
    local current_global
    current_global=$(asdf global "$name" 2>/dev/null | awk '{print $2}' | head -1)
    if [ "$current_global" = "$last_version" ]; then
    else
        asdf set -u "$name" "$last_version"
    fi
}

# Call the function with multiple versions
install_asdf_plugin nodejs https://github.com/asdf-vm/asdf-nodejs.git 20.10.0 18.4.0 18.3.0

ASDF_PYTHON_PATCH_URL="https://github.com/python/cpython/commit/8ea6353.patch?full_index=1"
install_asdf_plugin python https://github.com/asdf-community/asdf-python.git 3.10.0 3.6.12

install_asdf_plugin ruby https://github.com/asdf-vm/asdf-ruby.git 2.6.5 3.4.1

ASDF_GOLANG_OVERWRITE_ARCH=amd64 # Needed for M1
install_asdf_plugin golang https://github.com/asdf-community/asdf-golang.git 1.15.8

# Ensure 'python' points to 'python3' for all installed versions
for version in 3.10.0 3.6.12; do
  PYTHON_BIN="$HOME/.asdf/installs/python/$version/bin"
  if [ -d "$PYTHON_BIN" ]; then
    ln -sf "$PYTHON_BIN/python3" "$PYTHON_BIN/python"
    echo "Linked python3 to python in $PYTHON_BIN"
  fi
done

# ZSH Configs

curl https://gist.githubusercontent.com/LucianoAdonis/cce0307abc1385bc6cdc3671eb3f5821/raw > ~/.zshrc

# Brewfile

echo "Installing applications from Brewfile..."
curl -fsSL https://gist.githubusercontent.com/LucianoAdonis/43a43e5b80515abb828ceb1d3dca2258/raw > Brewfile
brew bundle install

echo ""
echo "=================================="
echo "✅ Bootstrap script completed!"
echo "=================================="
echo ""
echo "📋 Summary of changes:"
echo "  • Zsh and Oh My Zsh installed with plugins"
echo "  • Homebrew and ASDF configured"
echo "  • System preferences optimized"
echo "  • Finder configured with extensions visible"
echo "  • Downloads folder added to Dock (fan view, sorted by date created)"
echo "  • Security settings enabled (Firewall, Gatekeeper, HTTPS)"
echo "  • Developer tools and languages installed"
echo "  • Applications installed from Brewfile"
echo ""
echo "⚠️  Some changes require a logout/login or restart to take effect."
echo "⚠️  Check ~/SSH keys if you need to add them to GitHub/GitLab."
echo ""
echo "🎉 Your Mac is now ready for development!"