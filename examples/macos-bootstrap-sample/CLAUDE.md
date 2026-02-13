# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This repository contains macOS bootstrap automation scripts in two versions:

1. **Enhanced Version** - Traditional monolithic scripts with command-line feature toggles (`bootstrap.sh`, `macos-preferences.sh`)
2. **Modular Version** - Component-based architecture with separate module files (`modular/` directory)

Both versions accomplish the same goal: automate macOS system setup for developers.

## Architecture

### Enhanced Version Structure

```
bootstrap.sh                    # Main orchestrator with feature toggles at top
macos-preferences.sh           # System preferences configuration with feature toggles
```

**Key Design:**
- Feature toggles defined at the top as boolean variables
- Command-line flags (`--no-docker`, `--minimal`, etc.) override defaults
- All configuration wrapped in `if [ "$FEATURE_NAME" = true ]` blocks
- Helper functions for common operations (ensure_brew_cask, ensure_dock_app, etc.)

### Modular Version Structure

```
modular/
├── bootstrap-modular.sh       # Orchestrator that sources modules
├── config.sh                  # Central configuration (all feature toggles and settings)
└── modules/                   # 16 independent modules
    ├── xcode-cli.sh           # Xcode Command Line Tools
    ├── homebrew.sh            # Homebrew package manager
    ├── zsh.sh                 # Zsh shell configuration
    ├── keyboard.sh            # Keyboard/mouse settings
    ├── dock.sh                # Dock configuration
    ├── finder.sh              # Finder preferences
    ├── spotlight.sh           # Spotlight search categories
    ├── developer.sh           # Developer settings
    ├── security.sh            # Security configuration
    ├── asdf.sh                # ASDF version manager
    ├── git.sh                 # Git global configuration
    └── ... (5 more modules)
```

**Key Design:**
- All configuration centralized in `config.sh`
- Each module is self-contained and independently executable
- Orchestrator sources `config.sh` then conditionally runs modules
- Modules can be executed individually: `./bootstrap-modular.sh homebrew zsh`

## Critical Technical Details

### Spotlight Configuration Bug Fix

**IMPORTANT:** Spotlight category names are **always in English** internally, regardless of system language.

```bash
# ✅ CORRECT - Works on all systems
'{"enabled" = 1;"name" = "APPLICATIONS";}'

# ❌ WRONG - Spanish names don't exist in macOS
'{"enabled" = 1;"name" = "APLICACIONES";}'
```

This was the primary bug in the original implementation. The system displays localized names in the UI but stores them as English keys.

### macOS Configuration Pattern

All macOS system preferences follow this pattern:

```bash
# 1. Write preference using defaults command
defaults write <domain> <key> -<type> <value>

# 2. Restart the affected service to apply changes
killall Dock    # For Dock changes
killall Finder  # For Finder changes
killall Spotlight  # For Spotlight changes

# 3. Some changes require logout/restart (document these)
```

### Idempotency Requirements

All operations MUST be idempotent (safe to re-run):

```bash
# Check before install
if ! command -v brew >/dev/null 2>&1; then
    # Install only if not present
fi

# Check before configuration
if ! defaults read com.apple.dock persistent-apps | grep -q "app_path"; then
    # Add only if not already added
fi
```

## Common Tasks

### Testing Scripts Locally

```bash
# Enhanced version
./bootstrap.sh --help                    # See all options
./bootstrap.sh --no-docker --no-asdf     # Run without Docker/ASDF
./macos-preferences.sh --no-spotlight    # Skip Spotlight configuration

# Modular version
cd modular
./bootstrap-modular.sh --list            # List available modules
./bootstrap-modular.sh homebrew zsh      # Run specific modules only
```

### Adding New Features

**Enhanced Version:**
1. Add feature toggle at top: `CONFIGURE_NEW_FEATURE=true`
2. Add command-line flag parsing: `--no-new-feature) CONFIGURE_NEW_FEATURE=false ;;`
3. Wrap implementation: `if [ "$CONFIGURE_NEW_FEATURE" = true ]; then ... fi`

**Modular Version:**
1. Create new module: `modular/modules/new-feature.sh`
2. Add configuration to `modular/config.sh`: `CONFIGURE_NEW_FEATURE=true`
3. Add to orchestrator: `[ "$CONFIGURE_NEW_FEATURE" = true ] && run_module "new-feature"`
4. Make executable: `chmod +x modular/modules/new-feature.sh`

### Verifying Configuration Changes

```bash
# Check Dock configuration
defaults read com.apple.dock

# Check Finder settings
defaults read com.apple.finder

# Check Spotlight categories
defaults read com.apple.spotlight orderedItems

# Check system language
defaults read -g AppleLanguages

# Verify Gatekeeper status
spctl --status

# Check firewall state
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --getglobalstate
```

### Restarting Services After Changes

```bash
killall Dock       # Apply Dock changes immediately
killall Finder     # Apply Finder changes
killall Spotlight  # Apply Spotlight changes

# For system-wide changes, logout/login may be required
```

## Important Patterns

### macOS defaults Command Types

```bash
defaults write <domain> <key> -bool true/false      # Boolean
defaults write <domain> <key> -int 42               # Integer
defaults write <domain> <key> -float 2.5            # Float
defaults write <domain> <key> -string "value"       # String
defaults write <domain> <key> -array "item1" "item2"  # Array
defaults write <domain> <key> -dict key1 val1       # Dictionary
```

### Helper Function Pattern (Enhanced Version)

```bash
ensure_brew_cask() {
    local cask="$1"
    if ! brew list --cask 2>/dev/null | grep -q "^${cask}$"; then
        echo "Installing ${cask}..."
        brew install --cask "${cask}"
    else
        echo "✅ ${cask} already installed"
    fi
}
```

### Configuration Array Pattern (Modular Version)

```bash
# In config.sh
DOCK_APPS=(
    "/Applications/Google Chrome.app:Google Chrome"
    "/Applications/iTerm.app:iTerm"
)

# In module
for entry in "${DOCK_APPS[@]}"; do
    IFS=':' read -r app_path app_name <<< "$entry"
    ensure_dock_app "$app_path" "$app_name"
done
```

## Architecture Decisions

### Why Two Versions?

- **Enhanced Version**: Backward compatible, familiar structure, command-line flags for quick customization
- **Modular Version**: Maximum flexibility, easy to reference specific components, reusable modules

### Shared Design Principles

1. **Safety First**: `set -e`, `set -u`, error traps
2. **Idempotency**: Always check before installing/configuring
3. **Clear Feedback**: Progress messages and completion summaries
4. **Reversibility**: Document how to undo changes
5. **Security**: Enable features, never disable protections entirely

### Error Handling

Both versions use this pattern:

```bash
set -e  # Exit on error
set -u  # Exit on undefined variable
trap 'echo "❌ Error on line $LINENO. Exit code: $?"' ERR
```

## File Organization

### Enhanced Version Files
- `bootstrap.sh` - Main installation script (tools, languages, apps)
- `macos-preferences.sh` - System preferences only (can run standalone)

### Modular Version Files
- `bootstrap-modular.sh` - Orchestrator
- `config.sh` - All configuration in one place
- `modules/*.sh` - 16 independent modules

### Documentation Files
- `README.md` - Usage guide for both versions
- `IMPROVEMENTS.md` - Technical details of improvements and Spotlight fix
- `modular/README.md` - Modular version specific guide
- `SUMMARY.md` - Original project summary
- `CREATION_PROCESS.md` - Template creation process

## Common Pitfalls

1. **Never use `sudo` with Homebrew** - It will break permissions
2. **Always restart services after configuration** - Changes won't apply otherwise
3. **Test Spotlight configuration** - Category names are the most commonly misconfigured
4. **Check architecture (Intel vs Apple Silicon)** - Homebrew paths differ
5. **Don't hardcode user paths** - Use `$HOME` and environment variables
6. **Verify idempotency** - Every operation should be safe to re-run

## Key Configuration Examples

### Dock: Add App

```bash
defaults write com.apple.dock persistent-apps -array-add "
    <dict>
        <key>tile-data</key>
        <dict>
            <key>file-data</key>
            <dict>
                <key>_CFURLString</key>
                <string>file:///Applications/App.app</string>
                <key>_CFURLStringType</key>
                <integer>15</integer>
            </dict>
        </dict>
        <key>tile-type</key>
        <string>file-tile</string>
    </dict>
"
```

### Dock: Add Downloads Folder (Fan View)

```bash
defaults write com.apple.dock persistent-others -array-add '{
    "tile-data" = {
        "file-data" = {
            "_CFURLString" = "file://$HOME/Downloads/";
            "_CFURLStringType" = 15;
        };
        arrangement = 4;    # Sort by date created
        displayas = 0;      # Display as stack
        showas = 1;         # Show as fan
    };
    "tile-type" = "directory-tile";
}'
```

### Finder: Show Hidden Files and Extensions

```bash
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
killall Finder
```

### Security: Enable Firewall

```bash
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
```

## Git Configuration Details

Both versions include comprehensive Git global configuration:

**Settings Applied:**
- Default branch: `main`
- Pull strategy: rebase (cleaner history)
- Push default: simple with auto-setup remote tracking
- Diff algorithm: histogram with colorMoved for moved lines
- Merge conflict style: diff3 (shows common ancestor)
- Rerere: enabled (reuse recorded resolution)
- Fetch: auto-prune remote branches
- Credential helper: macOS Keychain
- Editor: Auto-detects VS Code, falls back to vim

**Git Aliases:**
- `co` = checkout
- `br` = branch
- `ci` = commit
- `st` = status
- `unstage` = reset HEAD --
- `last` = log -1 HEAD
- `visual` = log --oneline --graph --decorate --all
- `amend` = commit --amend --no-edit

**Global Gitignore:**
Creates `~/.gitignore_global` with common macOS and development files (.DS_Store, node_modules, __pycache__, .vscode, .idea, etc.)

**User Identity:**
Enhanced version: Prompts user to configure manually
Modular version: Can be set in config.sh via `GIT_USER_NAME` and `GIT_USER_EMAIL`

## Integration Points

- **Brewfile** - Both versions support loading application lists from a Brewfile URL
- **.zshrc** - Both versions can apply custom Zsh configuration from a URL
- **ASDF versions** - Configurable in feature toggles (Enhanced) or config.sh (Modular)
- **Git configuration** - Comprehensive settings with optional identity configuration
- **Login items** - Apps can be added to start on boot via osascript

## Testing Approach

No automated tests exist. Testing requires:

1. Run scripts on actual macOS system (VM or test machine)
2. Verify each configuration with `defaults read` commands
3. Check that services restart properly
4. Re-run script to verify idempotency
5. Test on both Intel and Apple Silicon architectures
6. Test with different language settings (English, Spanish)

## When Modifying Scripts

1. **Preserve idempotency** - Always check before installing/configuring
2. **Update both versions** - If fixing a bug, apply to both
3. **Test on real macOS** - No substitute for actual testing
4. **Document changes** - Update IMPROVEMENTS.md for technical details
5. **Maintain backward compatibility** - Enhanced version should not break existing usage
6. **Keep modules independent** - Modular version modules should not depend on each other
