#!/bin/bash

# ============================================================
# FEATURE TOGGLES - Enable/Disable Components
# ============================================================
INSTALL_XCODE_CLI=true
INSTALL_HOMEBREW=true
INSTALL_ZSH=true
INSTALL_OH_MY_ZSH=true
INSTALL_ZSH_PLUGINS=true
APPLY_MACOS_PREFERENCES=true
SET_DEFAULT_BROWSER=true
CONFIGURE_DOCKER=true
INSTALL_ASDF=true
INSTALL_ASDF_NODEJS=true
INSTALL_ASDF_PYTHON=true
INSTALL_ASDF_RUBY=true
INSTALL_ASDF_GOLANG=true
CONFIGURE_GIT=true
APPLY_CUSTOM_ZSHRC=true
INSTALL_APPLICATIONS=true
SETUP_LOGIN_ITEMS=true

# Parse command-line arguments
for arg in "$@"; do
  case "$arg" in
    --no-xcode) INSTALL_XCODE_CLI=false ;;
    --no-homebrew) INSTALL_HOMEBREW=false ;;
    --no-zsh) INSTALL_ZSH=false; INSTALL_OH_MY_ZSH=false; INSTALL_ZSH_PLUGINS=false ;;
    --no-preferences) APPLY_MACOS_PREFERENCES=false ;;
    --no-browser) SET_DEFAULT_BROWSER=false ;;
    --no-docker) CONFIGURE_DOCKER=false ;;
    --no-asdf) INSTALL_ASDF=false; INSTALL_ASDF_NODEJS=false; INSTALL_ASDF_PYTHON=false; INSTALL_ASDF_RUBY=false; INSTALL_ASDF_GOLANG=false ;;
    --no-git) CONFIGURE_GIT=false ;;
    --no-apps) INSTALL_APPLICATIONS=false ;;
    --minimal) INSTALL_APPLICATIONS=false; CONFIGURE_DOCKER=false; INSTALL_ASDF=false; SETUP_LOGIN_ITEMS=false ;;
    --help)
      echo "macOS Bootstrap Script"
      echo ""
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --no-xcode          Skip Xcode Command Line Tools"
      echo "  --no-homebrew       Skip Homebrew installation"
      echo "  --no-zsh            Skip Zsh and Oh My Zsh setup"
      echo "  --no-preferences    Skip macOS system preferences"
      echo "  --no-browser        Skip default browser configuration"
      echo "  --no-docker         Skip Docker configuration"
      echo "  --no-asdf           Skip ASDF and language runtimes"
      echo "  --no-git            Skip Git global configuration"
      echo "  --no-apps           Skip application installation"
      echo "  --minimal           Install only essentials (no apps, Docker, or ASDF)"
      echo "  --help              Show this help message"
      exit 0
      ;;
  esac
done

# Fail immediately on any errors
set -e
set -u

# Trap errors with helpful messages
trap 'echo "❌ Error on line $LINENO. Exit code: $?"' ERR

echo "🚀 Starting macOS bootstrap script..."
echo "=================================="
echo ""
echo "Enabled features:"
[ "$INSTALL_XCODE_CLI" = true ] && echo "  ✓ Xcode Command Line Tools"
[ "$INSTALL_HOMEBREW" = true ] && echo "  ✓ Homebrew"
[ "$INSTALL_ZSH" = true ] && echo "  ✓ Zsh & Oh My Zsh"
[ "$APPLY_MACOS_PREFERENCES" = true ] && echo "  ✓ macOS System Preferences"
[ "$SET_DEFAULT_BROWSER" = true ] && echo "  ✓ Default Browser Configuration"
[ "$CONFIGURE_DOCKER" = true ] && echo "  ✓ Docker"
[ "$INSTALL_ASDF" = true ] && echo "  ✓ ASDF & Language Runtimes"
[ "$CONFIGURE_GIT" = true ] && echo "  ✓ Git Global Configuration"
[ "$INSTALL_APPLICATIONS" = true ] && echo "  ✓ Applications"
echo ""

# Helpers
ensure_brew_cask() {
  local cask="$1"
  if ! brew list --cask 2>/dev/null | grep -q "^${cask}$"; then
    echo "Installing ${cask} (cask)..."
    brew install --cask "${cask}"
  else
    echo "✅ ${cask} already installed (cask)"
  fi
}

ensure_login_item_app() {
  local app_path="$1"     # e.g. /Applications/Rectangle.app
  local item_name="$2"    # e.g. Rectangle

  if [ ! -d "$app_path" ]; then
    echo "ℹ️  ${item_name} not found at ${app_path}; skipping login item"
    return 0
  fi

  # Idempotently add a login item (macOS-level). This may prompt for Automation permissions.
  if ! osascript >/dev/null 2>&1 <<EOF
tell application "System Events"
  if not (exists login item "${item_name}") then
    make login item at end with properties {name:"${item_name}", path:"${app_path}", hidden:false}
  end if
end tell
EOF
  then
    echo "⚠️  Could not add ${item_name} as a login item (may require Automation permission)."
    echo "   Add it manually: System Settings → General → Login Items"
    return 0
  fi

  echo "✅ ${item_name} will start at login"
}

# Check for Xcode Command Line Tools (required for git and other tools)
if [ "$INSTALL_XCODE_CLI" = true ]; then
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
fi

# Homebrew Installation (needed before other installations)
if [ "$INSTALL_HOMEBREW" = true ]; then
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
fi

# Zsh Installation (using Homebrew on macOS, not apt)
if [ "$INSTALL_ZSH" = true ]; then
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
fi

# Oh My Zsh Installation (non-interactive)
if [ "$INSTALL_OH_MY_ZSH" = true ]; then
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh..."
        # Use RUNZSH=no to prevent opening a new shell
        RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        echo "✅ Oh My Zsh installed successfully"
    else
        echo "✅ Oh My Zsh already installed"
    fi
fi

# ============================================================
# ZSH PLUGINS
# ============================================================
if [ "$INSTALL_ZSH_PLUGINS" = true ]; then
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
fi

# ============================================================
# MACOS SYSTEM PREFERENCES (sourced from separate script)
# ============================================================
# This sources macos-preferences.sh which contains all macOS
# settings that don't require package dependencies.
# You can run it standalone: ./macos-preferences.sh
# Or skip sleep settings: ./macos-preferences.sh --no-sleep
# ============================================================

if [ "$APPLY_MACOS_PREFERENCES" = true ]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    if [ -f "$SCRIPT_DIR/macos-preferences.sh" ]; then
        echo ""
        echo "📦 Applying macOS preferences..."
        source "$SCRIPT_DIR/macos-preferences.sh"
    else
        echo "⚠️  macos-preferences.sh not found; skipping system preferences"
    fi
fi

# Set Chrome as Default Browser (requires defaultbrowser from Homebrew)
if [ "$SET_DEFAULT_BROWSER" = true ]; then
    echo ""
    echo "🌐 Setting default browser..."
    if [ -d "/Applications/Google Chrome.app" ]; then
        if ! command -v defaultbrowser >/dev/null 2>&1; then
            echo "Installing defaultbrowser utility..."
            brew install defaultbrowser >/dev/null 2>&1 || true
        fi

        if command -v defaultbrowser >/dev/null 2>&1; then
            defaultbrowser chrome 2>/dev/null || true
            echo "✅ Chrome set as default browser (may require System Settings approval)"
        else
            echo "⚠️  Could not install/run 'defaultbrowser'."
            echo "   Set manually: System Settings → Desktop & Dock → Default web browser → Google Chrome"
        fi
    else
        echo "ℹ️  Chrome not installed, skipping default browser configuration"
    fi
fi

# ============================================================
# DOCKER CONFIGURATION
# ============================================================
if [ "$CONFIGURE_DOCKER" = true ]; then
    echo ""
    echo "🐳 Configuring Docker for always-on applications..."

    DOCKER_CONFIG_FILE="$HOME/.docker/daemon.json"

    ensure_brew_cask docker

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
fi

# ============================================================
# ASDF PLUGIN INSTALLATION
# ============================================================
if [ "$INSTALL_ASDF" = true ]; then
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

    # Install language runtimes based on feature toggles
    if [ "$INSTALL_ASDF_NODEJS" = true ]; then
        install_asdf_plugin nodejs https://github.com/asdf-vm/asdf-nodejs.git 20.10.0 18.4.0 18.3.0
    fi

    if [ "$INSTALL_ASDF_PYTHON" = true ]; then
        ASDF_PYTHON_PATCH_URL="https://github.com/python/cpython/commit/8ea6353.patch?full_index=1"
        install_asdf_plugin python https://github.com/asdf-community/asdf-python.git 3.10.0 3.6.12

        # Ensure 'python' points to 'python3' for all installed versions
        for version in 3.10.0 3.6.12; do
            PYTHON_BIN="$HOME/.asdf/installs/python/$version/bin"
            if [ -d "$PYTHON_BIN" ]; then
                ln -sf "$PYTHON_BIN/python3" "$PYTHON_BIN/python"
                echo "Linked python3 to python in $PYTHON_BIN"
            fi
        done
    fi

    if [ "$INSTALL_ASDF_RUBY" = true ]; then
        install_asdf_plugin ruby https://github.com/asdf-vm/asdf-ruby.git 2.6.5 3.4.1
    fi

    if [ "$INSTALL_ASDF_GOLANG" = true ]; then
        ASDF_GOLANG_OVERWRITE_ARCH=amd64 # Needed for M1
        install_asdf_plugin golang https://github.com/asdf-community/asdf-golang.git 1.15.8
    fi
fi

# ============================================================
# GIT GLOBAL CONFIGURATION
# ============================================================
if [ "$CONFIGURE_GIT" = true ]; then
    echo ""
    echo "🔧 Configuring Git global settings..."

    # Check if git is installed (should be via Xcode CLI or Homebrew)
    if ! command -v git >/dev/null 2>&1; then
        echo "⚠️  Git not found. Installing via Homebrew..."
        brew install git
    fi

    # Set default branch name to 'main'
    git config --global init.defaultBranch main
    echo "  ✓ Default branch set to 'main'"

    # Set pull strategy to rebase (cleaner history)
    git config --global pull.rebase true
    echo "  ✓ Pull strategy set to rebase"

    # Set push default to simple (push current branch to upstream)
    git config --global push.default simple
    echo "  ✓ Push default set to simple"

    # Automatically setup remote branch tracking
    git config --global push.autoSetupRemote true
    echo "  ✓ Auto setup remote branch tracking enabled"

    # Use diff3 conflict style (shows common ancestor)
    git config --global merge.conflictstyle diff3
    echo "  ✓ Merge conflict style set to diff3"

    # Enable rerere (reuse recorded resolution)
    git config --global rerere.enabled true
    echo "  ✓ Rerere (reuse recorded resolution) enabled"

    # Prune remote branches on fetch
    git config --global fetch.prune true
    echo "  ✓ Auto-prune remote branches on fetch"

    # Use more readable diffs
    git config --global diff.algorithm histogram
    echo "  ✓ Diff algorithm set to histogram"

    # Colorize output
    git config --global color.ui auto
    echo "  ✓ Colorized output enabled"

    # Show original branch names on merge conflicts
    git config --global merge.conflictStyle diff3
    echo "  ✓ Show original branch names in conflicts"

    # Rebase by default when pulling
    git config --global branch.autoSetupRebase always
    echo "  ✓ Auto-rebase on pull for all branches"

    # Useful aliases
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.st status
    git config --global alias.unstage 'reset HEAD --'
    git config --global alias.last 'log -1 HEAD'
    git config --global alias.visual 'log --oneline --graph --decorate --all'
    git config --global alias.amend 'commit --amend --no-edit'
    echo "  ✓ Git aliases configured (co, br, ci, st, unstage, last, visual, amend)"

    # Better diff for moved lines
    git config --global diff.colorMoved zebra
    echo "  ✓ Better diff for moved lines"

    # Set default editor (use system default or vim)
    if [ -n "${EDITOR:-}" ]; then
        git config --global core.editor "$EDITOR"
        echo "  ✓ Git editor set to $EDITOR"
    elif command -v code >/dev/null 2>&1; then
        git config --global core.editor "code --wait"
        echo "  ✓ Git editor set to VS Code"
    else
        git config --global core.editor vim
        echo "  ✓ Git editor set to vim"
    fi

    # Store credentials securely (macOS Keychain)
    git config --global credential.helper osxkeychain
    echo "  ✓ Credential helper set to macOS Keychain"

    # Better handling of whitespace
    git config --global core.whitespace trailing-space,space-before-tab
    echo "  ✓ Whitespace handling configured"

    # Exclude common files globally
    GLOBAL_GITIGNORE="$HOME/.gitignore_global"
    if [ ! -f "$GLOBAL_GITIGNORE" ]; then
        cat > "$GLOBAL_GITIGNORE" << 'EOF'
# macOS
.DS_Store
.AppleDouble
.LSOverride
Icon

# Thumbnails
._*

# Files that might appear in the root of a volume
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent

# Directories potentially created on remote AFP share
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk

# Editor files
*.swp
*.swo
*~
.vscode/
.idea/

# Node
node_modules/
npm-debug.log*

# Python
__pycache__/
*.py[cod]
.Python
venv/
.env

# Other
.env.local
.env.*.local
EOF
        git config --global core.excludesfile "$GLOBAL_GITIGNORE"
        echo "  ✓ Global gitignore created at $GLOBAL_GITIGNORE"
    else
        echo "  ✓ Global gitignore already exists at $GLOBAL_GITIGNORE"
    fi

    echo ""
    echo "ℹ️  NOTE: You still need to configure your Git identity:"
    echo "   git config --global user.name \"Your Name\""
    echo "   git config --global user.email \"your@email.com\""
    echo ""
    echo "✅ Git global configuration complete"
fi

# ============================================================
# ZSH CONFIGURATION
# ============================================================
if [ "$APPLY_CUSTOM_ZSHRC" = true ]; then
    echo ""
    echo "⚙️  Applying custom Zsh configuration..."
    curl -fsSL https://gist.githubusercontent.com/LucianoAdonis/cce0307abc1385bc6cdc3671eb3f5821/raw > ~/.zshrc
    echo "✅ Zsh configuration applied"
fi

# ============================================================
# APPLICATIONS INSTALLATION
# ============================================================
if [ "$INSTALL_APPLICATIONS" = true ]; then
    echo ""
    echo "📦 Installing applications from Brewfile..."
    curl -fsSL https://gist.githubusercontent.com/LucianoAdonis/43a43e5b80515abb828ceb1d3dca2258/raw > Brewfile
    brew bundle install --quiet

    echo "Ensuring required apps are installed..."
    ensure_brew_cask rectangle
    ensure_brew_cask clipy
    [ "$CONFIGURE_DOCKER" = true ] && ensure_brew_cask docker

    if [ "$SETUP_LOGIN_ITEMS" = true ]; then
        echo "Ensuring apps start automatically on login..."
        ensure_login_item_app "/Applications/Rectangle.app" "Rectangle"
        ensure_login_item_app "/Applications/Clipy.app" "Clipy"
        [ "$CONFIGURE_DOCKER" = true ] && ensure_login_item_app "/Applications/Docker.app" "Docker"
    fi

    echo "✅ Applications installed"
fi

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
echo "  ✓ Downloads added to Dock"
echo "  ✓ Security settings enabled (Firewall, Gatekeeper, passwords)"
echo "  ✓ Safari security configured"
echo "  ✓ Chrome set as default browser (if installed)"
echo "  ✓ Display sleep disabled for always-on applications"
echo "  ✓ Docker configured for always-on services"
echo "  ✓ Developer tools and languages installed via ASDF"
echo "  ✓ Git global configuration applied (default branch: main)"
echo "  ✓ Applications installed from Brewfile"
echo ""
echo "⚠️  Important notes:"
echo "  • Some changes require a logout/login or restart to take effect"
echo "  • Chrome as default browser may require System Preferences approval"
echo "  • Docker Desktop will need to be opened once to complete setup"
echo "  • Configure Git identity: git config --global user.name \"Your Name\""
echo "  •                        git config --global user.email \"your@email.com\""
echo "  • Check ~/.ssh/ for SSH keys if you need to add them to GitHub/GitLab"
echo ""
echo "💡 Quick tips:"
echo "  • To re-enable display sleep: sudo pmset -a displaysleep 10"
echo "  • To run always-on Docker apps: use --restart unless-stopped flag"
echo "  • To set Chrome as default: brew install defaultbrowser && defaultbrowser chrome"
echo ""
echo "🎉 Your Mac is now ready for development!"