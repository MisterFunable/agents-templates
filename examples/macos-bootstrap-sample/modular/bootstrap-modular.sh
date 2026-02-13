#!/bin/bash
# ============================================================
# MODULAR MACOS BOOTSTRAP SCRIPT
# ============================================================
# This is the main orchestrator that runs individual modules
# based on the configuration in config.sh.
#
# Usage:
#   ./bootstrap-modular.sh                    # Run all enabled modules
#   ./bootstrap-modular.sh homebrew zsh       # Run specific modules only
#   ./bootstrap-modular.sh --list             # List available modules
# ============================================================

set -e
set -u

# Trap errors with helpful messages
trap 'echo "❌ Error on line $LINENO. Exit code: $?"' ERR

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="$SCRIPT_DIR/modules"

# Load configuration
if [ -f "$SCRIPT_DIR/config.sh" ]; then
    source "$SCRIPT_DIR/config.sh"
else
    echo "❌ config.sh not found!"
    exit 1
fi

# ============================================================
# HELPER FUNCTIONS
# ============================================================

list_modules() {
    echo "Available modules:"
    echo ""
    echo "Core Tools:"
    echo "  xcode-cli      - Install Xcode Command Line Tools"
    echo "  homebrew       - Install Homebrew package manager"
    echo ""
    echo "Shell:"
    echo "  zsh            - Install and configure Zsh with Oh My Zsh"
    echo ""
    echo "macOS Preferences:"
    echo "  keyboard       - Configure keyboard and mouse settings"
    echo "  language       - Set system language"
    echo "  dock           - Configure Dock appearance and apps"
    echo "  finder         - Configure Finder settings"
    echo "  spotlight      - Configure Spotlight search categories"
    echo "  developer      - Configure developer-friendly settings"
    echo "  security       - Enable security features"
    echo "  safari         - Configure Safari security"
    echo "  sleep          - Configure power management"
    echo ""
    echo "Applications & Services:"
    echo "  docker         - Install and configure Docker"
    echo "  asdf           - Install ASDF version manager"
    echo "  git            - Configure Git global settings"
    echo "  applications   - Install applications from Brewfile"
    echo "  default-browser- Set default browser"
    echo ""
    echo "Usage:"
    echo "  ./bootstrap-modular.sh                  # Run all enabled modules"
    echo "  ./bootstrap-modular.sh homebrew zsh     # Run specific modules"
    echo "  ./bootstrap-modular.sh --list           # Show this list"
}

run_module() {
    local module_name="$1"
    local module_file="$MODULES_DIR/${module_name}.sh"

    if [ -f "$module_file" ]; then
        echo ""
        echo "▶️  Running module: $module_name"
        source "$module_file"
    else
        echo "⚠️  Module not found: $module_name"
    fi
}

# ============================================================
# MAIN EXECUTION
# ============================================================

echo "🚀 Starting Modular macOS Bootstrap"
echo "===================================="
echo ""

# Handle command-line arguments
if [ $# -gt 0 ]; then
    if [ "$1" = "--list" ] || [ "$1" = "-l" ]; then
        list_modules
        exit 0
    fi

    # Run specific modules
    echo "Running specific modules: $@"
    for module in "$@"; do
        run_module "$module"
    done
else
    # Run all enabled modules based on config
    echo "Running enabled modules from config.sh"
    echo ""

    # Core tools
    [ "$INSTALL_XCODE_CLI" = true ] && run_module "xcode-cli"
    [ "$INSTALL_HOMEBREW" = true ] && run_module "homebrew"

    # Shell
    [ "$INSTALL_ZSH" = true ] && run_module "zsh"

    # macOS Preferences
    [ "$CONFIGURE_KEYBOARD_MOUSE" = true ] && run_module "keyboard"
    [ "$CONFIGURE_LANGUAGE" = true ] && run_module "language"
    [ "$CONFIGURE_DOCK" = true ] && run_module "dock"
    [ "$CONFIGURE_FINDER" = true ] && run_module "finder"
    [ "$CONFIGURE_SPOTLIGHT" = true ] && run_module "spotlight"
    [ "$CONFIGURE_DEVELOPER" = true ] && run_module "developer"
    [ "$CONFIGURE_SECURITY" = true ] && run_module "security"
    [ "$CONFIGURE_SAFARI" = true ] && run_module "safari"
    [ "$CONFIGURE_SLEEP" = true ] && run_module "sleep"

    # Applications & Services
    [ "$SET_DEFAULT_BROWSER" = true ] && run_module "default-browser"
    [ "$CONFIGURE_DOCKER" = true ] && run_module "docker"
    [ "$INSTALL_ASDF" = true ] && run_module "asdf"
    [ "$CONFIGURE_GIT" = true ] && run_module "git"
    [ "$INSTALL_APPLICATIONS" = true ] && run_module "applications"
fi

echo ""
echo "===================================="
echo "✅ Bootstrap completed!"
echo "===================================="
echo ""
echo "⚠️  Some changes may require logout/restart to take effect."
