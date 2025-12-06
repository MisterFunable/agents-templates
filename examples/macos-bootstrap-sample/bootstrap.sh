#!/bin/bash

# Fail immediately on any errors
set -e
set -u

# Trap errors with helpful messages
trap 'echo "❌ Error on line $LINENO. Exit code: $?"' ERR

echo "🚀 Starting macOS bootstrap script..."
echo "=================================="

# Check for Xcode Command Line Tools (required for git and other tools)
echo "Checking for Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
    echo "⚠️  Xcode Command Line Tools not installed."
    echo "📦 Installing Xcode Command Line Tools..."
    echo ""
    echo "A dialog will appear. Please click 'Install' and wait for completion."
    echo "After installation completes, run this script again."
    echo ""
    xcode-select --install
    echo ""
    echo "❌ Exiting. Please run this script again after Xcode Command Line Tools installation completes."
    exit 1
else
    echo "✅ Xcode Command Line Tools already installed"
fi

# Homebrew Installation (needed before other installations)
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo "Adding Homebrew to PATH for Apple Silicon..."
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew already installed"
fi

# Zsh Installation (using Homebrew on macOS, not apt)
if ! command -v zsh >/dev/null 2>&1; then
    echo "Installing Zsh..."
    brew install zsh
    echo "✅ Zsh installed successfully"
else
    echo "✅ Zsh already installed"
fi

# Set Zsh as default shell
if [[ "$SHELL" != *"zsh"* ]]; then
    echo "Setting Zsh as default shell..."
    chsh -s "$(which zsh)"
    echo "✅ Zsh set as default shell"
fi

# Oh My Zsh Installation (non-interactive)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    # Use RUNZSH=no to prevent opening a new shell
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "✅ Oh My Zsh installed successfully"
else
    echo "✅ Oh My Zsh already installed"
fi

# ============================================================
# ZSH PLUGINS
# ============================================================
echo ""
echo "📦 Installing Zsh plugins..."

ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

install_zsh_plugin() {
    local url="$1"
    local dir="$ZSH_CUSTOM_DIR/plugins/$(basename "$url" .git)"

    if [ ! -d "$dir" ]; then
        echo "Installing $(basename "$url" .git)..."
        git clone "$url" "$dir" --quiet
        echo "✅ $(basename "$url" .git) installed"
    else
        echo "✅ $(basename "$url" .git) already installed"
    fi
}

install_zsh_plugin https://github.com/zsh-users/zsh-syntax-highlighting.git
install_zsh_plugin https://github.com/zsh-users/zsh-autosuggestions.git

# ============================================================
# MACOS SYSTEM PREFERENCES
# ============================================================
echo ""
echo "⚙️  Configuring macOS system preferences..."

echo "• Keyboard and mouse configurations..."
defaults write -g InitialKeyRepeat -int 35
defaults write -g KeyRepeat -int 2
defaults write -g com.apple.mouse.scaling 2.0
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode TwoButton

echo "• Setting language to Spanish..."
defaults write -g AppleLanguages -array "es-ES" 2>/dev/null || true

echo "• Configuring Dock..."
defaults delete com.apple.dock
defaults write com.apple.dock static-only -bool true
defaults write com.apple.dock show-recents -bool true

killall Dock

# echo "Computer name"
# sudo scutil --set HostName basic
# sudo scutil --set LocalHostName basic
# sudo scutil --set ComputerName basic # What you see in the Terminal
# dscacheutil -flushcache

echo "• Configuring Spotlight..."

# Detect the primary system language
LANGUAGE=$(defaults read -g AppleLanguages | head -2 | tail -1 | tr -d ' ",')
echo "  Detected language: $LANGUAGE"

if [[ "$LANGUAGE" == es* ]]; then
  echo "  Setting Spotlight order for Spanish..."
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
  echo "  Setting Spotlight order for English..."
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
echo "  Rebuilding Spotlight index..."
sudo mdutil -E / 2>/dev/null || echo "  Note: Spotlight rebuild requires admin privileges"

# Index Downloads folder specifically
mdimport ~/Downloads 2>/dev/null || true

echo "• Configuring Downloads folder in Dock..."

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

# ============================================================
# FINDER CONFIGURATION
# ============================================================
echo ""
echo "📁 Configuring Finder preferences..."

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

killall Finder 2>/dev/null || true

echo "✅ Finder configured"

# ============================================================
# SECURITY SETTINGS
# ============================================================
echo ""
echo "🔒 Configuring security settings..."

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

# ============================================================
# BROWSER CONFIGURATION
# ============================================================
echo ""
echo "🌐 Configuring browsers..."

# Safari settings require Safari to be closed
if pgrep -x "Safari" > /dev/null; then
    echo "⚠️  Safari is running. Some settings may not apply until Safari is restarted."
fi

# Try to configure Safari, but don't fail if it errors (sandboxed preferences)
{
    # Warn about fraudulent websites
    defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true 2>/dev/null || true
    
    # Block pop-ups
    defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false 2>/dev/null || true
    defaults write com.apple.Safari \
      com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false 2>/dev/null || true
    
    # Enable "Do Not Track"
    defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true 2>/dev/null || true
    
    echo "✅ Safari security settings configured (some settings may require manual configuration)"
} || {
    echo "⚠️  Safari settings may require manual configuration due to sandboxing"
}

# Set Chrome as Default Browser (if installed)
echo "• Setting default browser..."
if [ -d "/Applications/Google Chrome.app" ]; then
    # Set Chrome as default browser using defaultbrowser utility (will be installed via Homebrew)
    # Note: This requires user approval via System Preferences on first run
    if command -v defaultbrowser >/dev/null 2>&1; then
        defaultbrowser chrome 2>/dev/null || echo "⚠️  Run 'defaultbrowser chrome' manually after installation"
        echo "✅ Chrome set as default browser (may require System Preferences approval)"
    else
        echo "⚠️  'defaultbrowser' utility not found. Install with: brew install defaultbrowser"
        echo "   Then run: defaultbrowser chrome"
    fi
else
    echo "ℹ️  Chrome not installed, skipping default browser configuration"
fi

# ============================================================
# POWER MANAGEMENT & DISPLAY SETTINGS
# ============================================================
echo ""
echo "⚡ Configuring power management and display settings..."

# Disable screen sleep (display sleep only, not system sleep)
# 0 means never sleep for display
sudo pmset -a displaysleep 0 2>/dev/null || echo "⚠️  Display sleep configuration requires admin privileges"

# Prevent system sleep while display is on
sudo pmset -a sleep 0 2>/dev/null || echo "⚠️  System sleep configuration requires admin privileges"

# Disable screen saver
defaults -currentHost write com.apple.screensaver idleTime 0

# Alternative: Set screen saver to start after a long time (e.g., 3 hours = 10800 seconds)
# defaults -currentHost write com.apple.screensaver idleTime 10800

echo "✅ Display configured to never sleep (good for always-on applications)"
echo "ℹ️  To re-enable, use: sudo pmset -a displaysleep 10"

# ============================================================
# DEVELOPER & CREATIVE SETTINGS
# ============================================================
echo ""
echo "💻 Configuring developer and creative settings..."

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

# ============================================================
# DOCKER CONFIGURATION
# ============================================================
echo ""
echo "🐳 Configuring Docker for always-on applications..."

DOCKER_CONFIG_FILE="$HOME/.docker/daemon.json"

if command -v docker >/dev/null 2>&1 || [ -d "/Applications/Docker.app" ]; then
    # Create Docker config directory if it doesn't exist
    mkdir -p "$HOME/.docker"
    
    # Create or update daemon.json for optimal always-on app settings
    cat > "$DOCKER_CONFIG_FILE" << 'EOF'
{
  "debug": false,
  "experimental": false,
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "storage-driver": "overlay2",
  "builder": {
    "gc": {
      "enabled": true,
      "defaultKeepStorage": "20GB"
    }
  }
}
EOF
    
    echo "✅ Docker daemon configuration created at $DOCKER_CONFIG_FILE"
    echo "ℹ️  Docker settings optimized for always-on applications:"
    echo "   • Log rotation enabled (10MB max, 3 files)"
    echo "   • Garbage collection enabled (keeps 20GB)"
    echo "   • Optimized storage driver (overlay2)"
    echo ""
    echo "📝 To run n8n (or similar) as always-on service:"
    echo "   docker run -d --name n8n \\"
    echo "     --restart unless-stopped \\"
    echo "     -p 5678:5678 \\"
    echo "     -e N8N_BASIC_AUTH_ACTIVE=true \\"
    echo "     -e N8N_BASIC_AUTH_USER=admin \\"
    echo "     -e N8N_BASIC_AUTH_PASSWORD=password \\"
    echo "     -v ~/.n8n:/home/node/.n8n \\"
    echo "     n8nio/n8n"
    echo ""
    echo "   Key Docker flags for always-on apps:"
    echo "   • --restart unless-stopped : Auto-restart on reboot/crash"
    echo "   • -d : Run in detached mode (background)"
    echo "   • -v : Persist data across container restarts"
    echo ""
    
    # Set Docker to start on login (if Docker Desktop is installed)
    if [ -d "/Applications/Docker.app" ]; then
        echo "Setting Docker Desktop to start on login..."
        osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Docker.app", hidden:false}' 2>/dev/null || true
        echo "✅ Docker Desktop will start on login"
    fi
else
    echo "ℹ️  Docker not found. Install with: brew install --cask docker"
fi

# ============================================================
# ASDF PLUGIN INSTALLATION
# ============================================================
echo ""
echo "🔧 Installing ASDF plugins and language versions..."

# Check if ASDF is installed
if ! command -v asdf >/dev/null 2>&1; then
    echo "⚠️  ASDF not found. Installing via Homebrew..."
    brew install asdf
    
    # Add ASDF to shell
    echo ". $(brew --prefix asdf)/libexec/asdf.sh" >> ~/.zshrc
    source "$(brew --prefix asdf)/libexec/asdf.sh" 2>/dev/null || true
    
    echo "✅ ASDF installed"
fi

install_asdf_plugin() {
    local name="$1"
    local url="$2"
    shift 2

    echo "• Installing $name plugin..."
    if ! asdf plugin-list 2>/dev/null | grep -q "^$name$"; then
        asdf plugin add "$name" "$url" 2>/dev/null || echo "  ⚠️  Plugin add failed, may already exist"
    fi

    local all_versions_installed=true
    for version in "$@"; do
        if ! asdf list "$name" 2>/dev/null | grep -q "^  $version$"; then
            all_versions_installed=false
            break
        fi
    done

    if [ "$all_versions_installed" = true ]; then
        echo "  ✓ All $name versions already installed"
    else
        for version in "$@"; do
            if ! asdf list "$name" 2>/dev/null | grep -q "^  $version$"; then
                echo "  Installing $name $version..."
                asdf install "$name" "$version" || echo "  ⚠️  Failed to install $name $version"
            else
                echo "  ✓ $name $version already installed"
            fi
        done
    fi

    local last_version="${@: -1}"
    local current_global
    current_global=$(asdf global "$name" 2>/dev/null | awk '{print $2}' | head -1)
    if [ "$current_global" != "$last_version" ]; then
        asdf global "$name" "$last_version" 2>/dev/null || true
        echo "  ✓ Set $name global version to $last_version"
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

# ============================================================
# ZSH CONFIGURATION
# ============================================================
echo ""
echo "⚙️  Applying custom Zsh configuration..."
curl -fsSL https://gist.githubusercontent.com/LucianoAdonis/cce0307abc1385bc6cdc3671eb3f5821/raw > ~/.zshrc
echo "✅ Zsh configuration applied"

# ============================================================
# APPLICATIONS INSTALLATION
# ============================================================
echo ""
echo "📦 Installing applications from Brewfile..."
curl -fsSL https://gist.githubusercontent.com/LucianoAdonis/43a43e5b80515abb828ceb1d3dca2258/raw > Brewfile
brew bundle install --quiet
echo "✅ Applications installed"

echo ""
echo "=================================="
echo "✅ Bootstrap script completed!"
echo "=================================="
echo ""
echo "📋 Summary of changes:"
echo "  ✓ Xcode Command Line Tools verified"
echo "  ✓ Homebrew installed and configured"
echo "  ✓ Zsh and Oh My Zsh installed with plugins"
echo "  ✓ System preferences optimized for development"
echo "  ✓ Keyboard, mouse, and language settings configured"
echo "  ✓ Finder configured with extensions and hidden files visible"
echo "  ✓ Downloads folder added to Dock (fan view, date sorted)"
echo "  ✓ Security settings enabled (Firewall, Gatekeeper, passwords)"
echo "  ✓ Safari security configured"
echo "  ✓ Chrome set as default browser (if installed)"
echo "  ✓ Display sleep disabled for always-on applications"
echo "  ✓ Docker configured for always-on services"
echo "  ✓ Developer tools and languages installed via ASDF"
echo "  ✓ Applications installed from Brewfile"
echo ""
echo "⚠️  Important notes:"
echo "  • Some changes require a logout/login or restart to take effect"
echo "  • Chrome as default browser may require System Preferences approval"
echo "  • Docker Desktop will need to be opened once to complete setup"
echo "  • Check ~/.ssh/ for SSH keys if you need to add them to GitHub/GitLab"
echo ""
echo "💡 Quick tips:"
echo "  • To re-enable display sleep: sudo pmset -a displaysleep 10"
echo "  • To run always-on Docker apps: use --restart unless-stopped flag"
echo "  • To set Chrome as default: brew install defaultbrowser && defaultbrowser chrome"
echo ""
echo "🎉 Your Mac is now ready for development!"