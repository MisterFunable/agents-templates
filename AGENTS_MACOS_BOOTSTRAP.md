# AGENTS_MACOS_BOOTSTRAP.md

Instructions for AI models creating macOS bootstrapping scripts for developer/devops/creative workflows.

Use this when setting up a new macOS machine with automated configuration scripts.

## Script Structure

Standard macOS bootstrap script layout:

```
bootstrap.sh                 # Main bootstrapping script
├── Error handling setup    # set -e, error trapping
├── Prerequisite checks     # OS version, architecture
├── System configurations   # Keyboard, mouse, language
├── Finder & Dock settings  # Views, sidebar, organization
├── Security settings       # Gatekeeper, firewall, HTTPS
├── Package managers        # Homebrew, ASDF installation
├── Development tools       # Languages, runtimes, CLIs
├── Application installs    # GUI apps via Homebrew Cask
├── Shell configuration     # Zsh, plugins, dotfiles
└── Cleanup & restart       # Apply changes, restart services
```

Optional companion files:
```
Brewfile                    # Homebrew bundle dependencies
.zshrc                      # Shell configuration (from gist)
.tool-versions              # ASDF version management
```

## Error Handling and Safety

Every bootstrapping script must be safe and resumable.

**Required safety measures:**

```bash
#!/bin/bash

# Exit on any error
set -e

# Exit on undefined variable
set -u

# Print commands as they execute (optional, for debugging)
# set -x

# Trap errors and provide helpful messages
trap 'echo "Error on line $LINENO. Exit code: $?"' ERR
```

**Idempotent operations:**

Every command should be safe to run multiple times.

```bash
# Good - checks before installing
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed."
fi

# Bad - fails on second run
brew install git
```

**Check prerequisites:**

```bash
# Check macOS version
if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "Error: This script is for macOS only"
    exit 1
fi

# Check for required commands
for cmd in curl git; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "Error: Required command '$cmd' not found"
        exit 1
    fi
done
```

## System Configuration

Use `defaults` command for macOS preferences. All settings must be testable and reversible.

**Keyboard and mouse settings:**

```bash
# Fast key repeat (requires logout)
defaults write -g InitialKeyRepeat -int 15  # Default is 25 (15*15ms = 225ms)
defaults write -g KeyRepeat -int 2          # Default is 6 (2*15ms = 30ms)

# Disable press-and-hold for accent characters (enables key repeat)
defaults write -g ApplePressAndHoldEnabled -bool false

# Mouse acceleration
defaults write -g com.apple.mouse.scaling 2.0

# Enable secondary click on Magic Mouse
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode TwoButton

# Trackpad: enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
```

**Language and locale:**

```bash
# Set system language (requires logout)
defaults write -g AppleLanguages -array "en-US" "es-ES"

# Set locale
defaults write -g AppleLocale -string "en_US@currency=USD"

# Set measurement units
defaults write -g AppleMeasurementUnits -string "Centimeters"
defaults write -g AppleMetricUnits -bool true
```

**Computer name:**

```bash
# Set computer name (requires sudo)
sudo scutil --set ComputerName "MacBook-Dev"
sudo scutil --set HostName "macbook-dev"
sudo scutil --set LocalHostName "macbook-dev"
sudo dscacheutil -flushcache
```

## Finder Configuration

Configure Finder views, sidebar, and folder preferences.

**Finder preferences:**

```bash
# Show hidden files
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show file extensions
defaults write -g AppleShowAllExtensions -bool true

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Default to list view
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable warning when changing file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Disable .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable .DS_Store files on USB volumes
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Search current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Keep folders on top when sorting
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Restart Finder to apply changes
killall Finder
```

**Downloads folder fan view:**

To configure the Downloads folder in Dock with fan view and date sorting:

```bash
# Remove existing Downloads folder from Dock if present
defaults delete com.apple.dock persistent-others 2>/dev/null || true

# Add Downloads folder to Dock
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
      <integer>2</integer>
      <key>displayas</key>
      <integer>1</integer>
      <key>showas</key>
      <integer>1</integer>
    </dict>
    <key>tile-type</key>
    <string>directory-tile</string>
  </dict>
"

# Restart Dock to apply changes
killall Dock
```

**Folder view options:**
- `arrangement`: Sort order (1=Name, 2=Date Added, 3=Date Modified, 4=Date Created, 5=Kind)
- `displayas`: Display as (0=Stack, 1=Folder)
- `showas`: View as (0=Automatic, 1=Fan, 2=Grid, 3=List)

## Dock Configuration

Dock behavior and organization settings.

```bash
# Auto-hide Dock
defaults write com.apple.dock autohide -bool true

# Set Dock icon size (pixels)
defaults write com.apple.dock tilesize -int 48

# Minimize windows using scale effect
defaults write com.apple.dock mineffect -string "scale"

# Show only open applications
defaults write com.apple.dock static-only -bool true

# Don't show recent applications
defaults write com.apple.dock show-recents -bool false

# Position on screen (left, bottom, right)
defaults write com.apple.dock orientation -string "bottom"

# Minimize windows into application icon
defaults write com.apple.dock minimize-to-application -bool true

# Remove all default apps from Dock (clean slate)
defaults write com.apple.dock persistent-apps -array

# Add specific apps to Dock
defaults write com.apple.dock persistent-apps -array-add "
  <dict>
    <key>tile-data</key>
    <dict>
      <key>file-data</key>
      <dict>
        <key>_CFURLString</key>
        <string>file:///Applications/Visual%20Studio%20Code.app/</string>
        <key>_CFURLStringType</key>
        <integer>15</integer>
      </dict>
    </dict>
  </dict>
"

# Restart Dock
killall Dock
```

## Spotlight Configuration

Configure Spotlight search categories and indexing.

**Spotlight search results order:**

```bash
# Detect system language for proper category names
LANGUAGE=$(defaults read -g AppleLanguages | head -2 | tail -1 | tr -d ' ",')

if [[ "$LANGUAGE" == es* ]]; then
  defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 1;"name" = "APLICACIONES";}' \
    '{"enabled" = 1;"name" = "DICCIONARIO";}' \
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
sudo mdutil -E /

# Index specific folder
mdimport ~/Downloads
```

**Spotlight category names:**

| English | Spanish | Description |
|---------|---------|-------------|
| APPLICATIONS | APLICACIONES | Applications |
| MENU_DEFINITION | DICCIONARIO | Dictionary definitions |
| DOCUMENTS | DOCUMENTOS | Documents |
| DIRECTORIES | DIRECTORIOS | Folders |
| PDF | PDF | PDF files |
| FONTS | FUENTES | Fonts |
| MESSAGES | MENSAJES | Messages |
| CONTACT | CONTACTOS | Contacts |
| EVENT_TODO | EVENTOS_Y_TAREAS | Calendar events |
| IMAGES | IMÁGENES | Images |
| BOOKMARKS | MARCADORES | Bookmarks |
| MUSIC | MÚSICA | Music |
| MOVIES | PELÍCULAS | Movies |
| PRESENTATIONS | PRESENTACIONES | Keynote/PowerPoint |
| SPREADSHEETS | HOJAS_DE_CÁLCULO | Excel/Numbers |
| SOURCE | CÓDIGO_FUENTE | Source code |
| SYSTEM_PREFS | PREFERENCIAS_DEL_SISTEMA | System Preferences |

## Security Configuration

Security settings for developers who need flexibility without compromising safety.

**Gatekeeper (app verification):**

```bash
# Allow apps from App Store and identified developers
sudo spctl --master-enable

# Check Gatekeeper status
spctl --status

# Allow a specific app to run (if blocked)
sudo xattr -rd com.apple.quarantine /Applications/AppName.app

# Temporarily disable Gatekeeper (NOT RECOMMENDED)
# sudo spctl --master-disable
```

**Firewall configuration:**

```bash
# Enable firewall
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on

# Enable stealth mode (don't respond to ICMP ping)
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on

# Enable logging
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setloggingmode on

# Restart firewall
sudo pkill -HUP socketfilterfw
```

**Safari HTTPS enforcement:**

```bash
# Upgrade to HTTPS automatically
defaults write com.apple.Safari \
  com.apple.Safari.ContentPageGroupIdentifier.WebKit2UpgradeKnownHostsToHTTPS -bool true

# Warn about fraudulent websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Block pop-ups
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

# Enable "Do Not Track"
defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true
```

**System security settings:**

```bash
# Require password immediately after sleep or screen saver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Disable remote Apple events
sudo systemsetup -setremoteappleevents off

# Disable wake on network access
sudo systemsetup -setwakeonnetworkaccess off

# Disable guest user
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false

# Enable secure keyboard entry in Terminal
defaults write com.apple.terminal SecureKeyboardEntry -bool true

# Disable crash reporter
defaults write com.apple.CrashReporter DialogType -string "none"
```

**FileVault (disk encryption):**

```bash
# Check FileVault status
sudo fdesetup status

# Enable FileVault (requires user interaction)
# sudo fdesetup enable
```

## Package Managers

Install and configure Homebrew and ASDF for managing packages and language versions.

**Homebrew installation:**

```bash
# Install Homebrew
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add to PATH for Apple Silicon
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed."
    brew update
fi

# Install essential packages
brew install git curl wget tree jq

# Install GUI applications
brew install --cask \
    visual-studio-code \
    iterm2 \
    docker \
    slack \
    postman \
    notion \
    rectangle \
    alfred

# Or use Brewfile
brew bundle install
```

**ASDF installation:**

```bash
# Install ASDF via Homebrew
brew install asdf

# Add to shell (Zsh)
echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ~/.zshrc

# Install ASDF plugins
install_asdf_plugin() {
    local name="$1"
    local url="$2"
    shift 2
    local versions=("$@")
    
    # Add plugin if not exists
    if ! asdf plugin-list | grep -q "^$name$"; then
        echo "Installing $name plugin..."
        asdf plugin add "$name" "$url"
    else
        echo "$name plugin already installed."
    fi
    
    # Install versions
    for version in "${versions[@]}"; do
        if ! asdf list "$name" | grep -q "^\s*$version$"; then
            echo "Installing $name $version..."
            asdf install "$name" "$version"
        else
            echo "$name $version already installed."
        fi
    done
    
    # Set global version to latest provided
    asdf global "$name" "${versions[-1]}"
}

# Install languages
install_asdf_plugin nodejs https://github.com/asdf-vm/asdf-nodejs.git 18.20.0 20.10.0
install_asdf_plugin python https://github.com/asdf-community/asdf-python.git 3.11.7 3.12.1
install_asdf_plugin ruby https://github.com/asdf-vm/asdf-ruby.git 3.2.2
install_asdf_plugin golang https://github.com/asdf-community/asdf-golang.git 1.21.5

# Reshim to update binaries
asdf reshim
```

## Shell Configuration

Set up Zsh with Oh My Zsh, plugins, and themes.

**Zsh and Oh My Zsh:**

```bash
# Install Zsh (usually pre-installed on macOS)
if ! command -v zsh >/dev/null 2>&1; then
    brew install zsh
fi

# Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
```

**Zsh plugins:**

```bash
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install plugin helper function
install_zsh_plugin() {
    local url="$1"
    local plugin_name=$(basename "$url" .git)
    local plugin_dir="$ZSH_CUSTOM/plugins/$plugin_name"
    
    if [ ! -d "$plugin_dir" ]; then
        echo "Installing $plugin_name..."
        git clone "$url" "$plugin_dir"
    else
        echo "$plugin_name already installed."
    fi
}

# Essential plugins
install_zsh_plugin https://github.com/zsh-users/zsh-syntax-highlighting.git
install_zsh_plugin https://github.com/zsh-users/zsh-autosuggestions.git
install_zsh_plugin https://github.com/zsh-users/zsh-completions.git

# Update .zshrc plugins line
# plugins=(git asdf docker kubectl zsh-syntax-highlighting zsh-autosuggestions zsh-completions)
```

**Theme installation (Powerlevel10k):**

```bash
# Install Powerlevel10k theme
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
        "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Install recommended fonts
brew tap homebrew/cask-fonts
brew install --cask font-meslo-lg-nerd-font

# Set theme in .zshrc
# ZSH_THEME="powerlevel10k/powerlevel10k"
```

**Dotfiles from gist:**

```bash
# Download and apply .zshrc from gist
ZSHRC_GIST_URL="https://gist.githubusercontent.com/username/gist-id/raw"

if [ -n "$ZSHRC_GIST_URL" ]; then
    echo "Downloading .zshrc from gist..."
    curl -fsSL "$ZSHRC_GIST_URL" > ~/.zshrc
    source ~/.zshrc
fi

# Backup existing config before overwriting
if [ -f ~/.zshrc ]; then
    cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
fi
```

## Developer-Specific Settings

Additional settings useful for developers, devops engineers, and creative professionals.

**Terminal and editor settings:**

```bash
# Set Visual Studio Code as default editor
export EDITOR="code -w"
export VISUAL="code -w"

# Add VS Code to PATH
sudo ln -sf "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" \
    /usr/local/bin/code

# Terminal theme
defaults write com.apple.terminal "Default Window Settings" -string "Pro"
defaults write com.apple.terminal "Startup Window Settings" -string "Pro"
```

**Git configuration:**

```bash
# Set Git user
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set default branch name
git config --global init.defaultBranch main

# Enable credential helper
git config --global credential.helper osxkeychain

# Set default editor
git config --global core.editor "code -w"

# Better diffs
git config --global diff.algorithm histogram
git config --global diff.compactionHeuristic true

# Useful aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
```

**SSH key generation:**

```bash
# Generate SSH key for GitHub
if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -C "your.email@example.com" -f ~/.ssh/id_ed25519 -N ""
    
    # Start SSH agent
    eval "$(ssh-agent -s)"
    
    # Add key to agent
    ssh-add ~/.ssh/id_ed25519
    
    # Copy public key to clipboard
    pbcopy < ~/.ssh/id_ed25519.pub
    
    echo "SSH public key copied to clipboard. Add it to GitHub: https://github.com/settings/keys"
fi
```

**Docker Desktop configuration:**

```bash
# Install Docker Desktop
brew install --cask docker

# Docker completion for Zsh (add to .zshrc)
# plugins=(... docker docker-compose)

# Docker aliases
alias dps="docker ps"
alias dimg="docker images"
alias dstop="docker stop"
alias drm="docker rm"
alias drmi="docker rmi"
```

**Creative tools:**

```bash
# Install creative applications
brew install --cask \
    figma \
    adobe-creative-cloud \
    blender \
    obs \
    vlc \
    handbrake \
    imageoptim \
    kap

# Install media CLI tools
brew install ffmpeg imagemagick youtube-dl
```

**Productivity tools:**

```bash
# Window management
brew install --cask rectangle

# Clipboard manager
brew install --cask flycut

# Menu bar customization
brew install --cask hidden

# Quick launcher
brew install --cask alfred

# Time tracking
brew install --cask toggl-track

# Screen recording
brew install --cask kap
```

## Anti-Patterns

| Don't | Do |
|-------|-----|
| Run commands without checking if already installed | Always check with `command -v` or test for files/directories |
| Use `sudo` for Homebrew installations | Never use `sudo` with `brew` commands |
| Hardcode absolute paths for user directories | Use `$HOME` or `~` for user-relative paths |
| Set `defaults` without testing the domain/key exists | Test settings with `defaults read` first |
| Forget to restart services after configuration | Always `killall Dock`, `killall Finder` after changes |
| Download scripts and pipe directly to `sh` | Download first, inspect, then execute |
| Modify system files in `/System/` or `/Library/` | Use user-level `~/Library/` preferences when possible |
| Install GUI apps with `sudo` or outside of `/Applications/` | Use `brew install --cask` for standard locations |
| Set security settings without explaining implications | Comment why each security setting is being changed |
| Overwrite existing dotfiles without backup | Always create timestamped backups before replacing |
| Use `curl` without `-f` (fail silently) | Always use `curl -fsSL` for safer downloads |
| Set language/locale without checking current values | Detect and preserve user's language preferences |

## Quick Reference

| Aspect | Standard |
|--------|----------|
| Error handling | `set -e`, `set -u`, `trap` for errors |
| Idempotency | Check before install, safe to re-run |
| Package manager | Homebrew for macOS packages and apps |
| Language manager | ASDF for multiple runtime versions |
| Shell | Zsh with Oh My Zsh |
| Dotfiles location | `~/` (home directory) |
| Configuration method | `defaults write` for macOS preferences |
| Service restart | `killall` after `defaults` changes |
| Security | Firewall on, Gatekeeper enabled, HTTPS enforced |
| Git default branch | `main` |
| Editor | Visual Studio Code |
| Downloads view | Fan view, sorted by date created |
| Finder view | List view with extensions shown |
| Dock | Auto-hide, minimal icons |

## When Creating macOS Bootstrap Scripts

1. **Start with safety first** - Add error handling and idempotent checks
2. **Test prerequisites** - Check macOS version, required commands, permissions
3. **Detect before changing** - Read current language, architecture, installed tools
4. **Group by domain** - System, Finder, Dock, Security, Development, Applications
5. **Comment extensively** - Explain what each `defaults` command does
6. **Use functions** - Create reusable functions for plugin/package installation
7. **Restart services** - `killall Dock`, `killall Finder` after preference changes
8. **Backup before overwriting** - Always backup dotfiles with timestamps
9. **Provide feedback** - Echo progress messages for long-running operations
10. **Test on clean system** - Bootstrap scripts should work on fresh macOS install
11. **Document manual steps** - Some settings require GUI interaction (FileVault, SSH keys)
12. **Version control** - Keep bootstrap scripts in git with versioned changes

## Common Issues and Solutions

**Spotlight category names not working:**
- Category names are language-specific
- Detect system language first with `defaults read -g AppleLanguages`
- Use correct localized names (e.g., `APLICACIONES` vs `APPLICATIONS`)

**Dock Downloads folder not appearing as fan:**
- Must use proper plist dictionary format with all required keys
- `arrangement=2` for date added, `displayas=1` for folder, `showas=1` for fan
- Always `killall Dock` after changes

**Gatekeeper blocking developer tools:**
- Use `sudo xattr -rd com.apple.quarantine` to remove quarantine flag
- Don't disable Gatekeeper entirely; whitelist specific apps

**Homebrew PATH not found:**
- Apple Silicon Macs use `/opt/homebrew/bin`
- Intel Macs use `/usr/local/bin`
- Add `eval "$(/opt/homebrew/bin/brew shellenv)"` to shell profile

**ASDF shims not working:**
- Must source ASDF in shell: `. $(brew --prefix asdf)/libexec/asdf.sh`
- Run `asdf reshim` after installing new packages

**Settings not persisting after reboot:**
- Some `defaults` require logout/login
- System Integrity Protection (SIP) blocks some modifications
- Check if domain is protected with `defaults read <domain>`

---

For examples of complete bootstrap scripts, see `examples/bootstrap-sample/` in this repository.

