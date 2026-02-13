# macOS Bootstrap Improvements

This document describes the improvements made to the macOS bootstrap automation scripts.

## What's New

### 1. Feature Toggles (Enhanced Version)
Both `bootstrap.sh` and `macos-preferences.sh` now support command-line flags to enable/disable specific features.

**bootstrap.sh Options:**
```bash
./bootstrap.sh                  # Run all features
./bootstrap.sh --no-xcode       # Skip Xcode CLI installation
./bootstrap.sh --no-homebrew    # Skip Homebrew
./bootstrap.sh --no-zsh         # Skip Zsh setup
./bootstrap.sh --no-preferences # Skip macOS system preferences
./bootstrap.sh --no-docker      # Skip Docker configuration
./bootstrap.sh --no-asdf        # Skip ASDF and language runtimes
./bootstrap.sh --no-git         # Skip Git global configuration
./bootstrap.sh --no-apps        # Skip application installation
./bootstrap.sh --minimal        # Install only essentials
./bootstrap.sh --help           # Show help
```

**macos-preferences.sh Options:**
```bash
./macos-preferences.sh                 # Run all settings
./macos-preferences.sh --no-keyboard   # Skip keyboard/mouse
./macos-preferences.sh --no-dock       # Skip Dock configuration
./macos-preferences.sh --no-spotlight  # Skip Spotlight
./macos-preferences.sh --no-security   # Skip security settings
./macos-preferences.sh --no-sleep      # Skip power settings
./macos-preferences.sh --minimal       # Basic settings only
./macos-preferences.sh --help          # Show help
```

### 2. Fixed Spotlight Configuration
**Problem:** Spotlight category names were incorrectly assumed to be language-specific, causing configuration to fail.

**Solution:**
- Spotlight category names are **always in English** internally, regardless of system language
- Removed Spanish-specific category names (APLICACIONES, DOCUMENTOS, etc.)
- Now uses correct English keys (APPLICATIONS, DOCUMENTS, etc.)
- Added detection logic to read current configuration before applying changes

**Why it failed before:**
```bash
# WRONG - Spanish names don't exist
defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 1;"name" = "APLICACIONES";}'  # ❌ Invalid
```

**Correct approach:**
```bash
# CORRECT - English names always work
defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 1;"name" = "APPLICATIONS";}'  # ✅ Valid
```

### 3. Git Global Configuration
Comprehensive Git configuration with developer-friendly defaults:

**What's Configured:**
- Default branch name set to `main`
- Pull strategy set to rebase for cleaner history
- Push defaults and auto-setup remote tracking
- Better diff algorithms (histogram, colorMoved)
- Merge conflict style showing common ancestor (diff3)
- Rerere (reuse recorded resolution) enabled
- Auto-prune remote branches on fetch
- Useful aliases (co, br, ci, st, unstage, last, visual, amend)
- VS Code or vim as default editor (auto-detected)
- macOS Keychain credential helper
- Global .gitignore with macOS and common development files

**User Configuration:**
The script reminds you to set your identity manually:
```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

Or in the modular version, set these in `config.sh`:
```bash
GIT_USER_NAME="Your Name"
GIT_USER_EMAIL="your@email.com"
```

### 4. Modular Version
A completely new structure that splits functionality into separate, reusable modules.

**Directory Structure:**
```
modular/
├── bootstrap-modular.sh     # Main orchestrator
├── config.sh                # Central configuration file
└── modules/
    ├── xcode-cli.sh         # Xcode Command Line Tools
    ├── homebrew.sh          # Homebrew package manager
    ├── zsh.sh               # Zsh shell setup
    ├── keyboard.sh          # Keyboard & mouse settings
    ├── language.sh          # System language
    ├── dock.sh              # Dock configuration
    ├── finder.sh            # Finder settings
    ├── spotlight.sh         # Spotlight configuration
    ├── developer.sh         # Developer settings
    ├── security.sh          # Security settings
    ├── safari.sh            # Safari configuration
    ├── sleep.sh             # Power management
    ├── docker.sh            # Docker setup
    ├── asdf.sh              # ASDF & language runtimes
    ├── git.sh               # Git global configuration
    ├── applications.sh      # App installation
    └── default-browser.sh   # Default browser setup
```

## Usage Examples

### Enhanced Version (Original Structure)

**Full installation:**
```bash
./bootstrap.sh
```

**Minimal installation (no apps, Docker, or ASDF):**
```bash
./bootstrap.sh --minimal
```

**Custom installation:**
```bash
./bootstrap.sh --no-docker --no-asdf
```

**Only system preferences:**
```bash
./macos-preferences.sh
```

**System preferences without Spotlight:**
```bash
./macos-preferences.sh --no-spotlight
```

### Modular Version

**Full installation:**
```bash
cd modular
./bootstrap-modular.sh
```

**Run specific modules only:**
```bash
./bootstrap-modular.sh homebrew zsh docker
```

**List available modules:**
```bash
./bootstrap-modular.sh --list
```

**Customize configuration:**
```bash
# Edit config.sh to enable/disable features
vim config.sh

# Then run bootstrap
./bootstrap-modular.sh
```

## Configuration (Modular Version)

All settings are centralized in `modular/config.sh`:

```bash
# Core Tools
INSTALL_XCODE_CLI=true
INSTALL_HOMEBREW=true

# Shell
INSTALL_ZSH=true
ZSHRC_URL="https://gist.githubusercontent.com/YourUsername/your-gist/raw"

# macOS Preferences
CONFIGURE_KEYBOARD_MOUSE=true
KEY_REPEAT_INITIAL=35  # Customize keyboard repeat speed
CONFIGURE_DOCK=true
CONFIGURE_SPOTLIGHT=true

# Applications
INSTALL_APPLICATIONS=true
BREWFILE_URL="https://gist.githubusercontent.com/YourUsername/brewfile/raw"

# ASDF Runtimes
INSTALL_ASDF=true
NODEJS_VERSIONS=("20.10.0" "18.4.0")
PYTHON_VERSIONS=("3.10.0" "3.6.12")
```

## Benefits

### Enhanced Version Benefits
1. **Flexibility** - Enable/disable features without editing code
2. **Backward Compatible** - Same file structure as before
3. **Quick Testing** - Test specific features in isolation

### Modular Version Benefits
1. **Easy to Reference** - Each component in its own file
2. **Reusable** - Import individual modules into other scripts
3. **Maintainable** - Changes isolated to specific modules
4. **Testable** - Test modules independently
5. **Customizable** - Single config file for all settings
6. **Selective Execution** - Run only what you need

## Migration Guide

### From Original to Enhanced Version
No migration needed! The enhanced version is backward compatible.

### From Original to Modular Version
1. Copy your customizations to `modular/config.sh`
2. Update URLs for your Brewfile and .zshrc
3. Customize version arrays for language runtimes
4. Run `./bootstrap-modular.sh`

## Which Version Should You Use?

### Use Enhanced Version If:
- You want minimal changes to existing setup
- You prefer traditional single-file scripts
- You're already familiar with the structure

### Use Modular Version If:
- You want maximum flexibility
- You need to reference specific configurations often
- You want to customize individual components
- You're building automation workflows
- You plan to extend or modify the scripts frequently

## Spotlight Issue - Technical Details

### Root Cause
The original script attempted to use localized category names based on system language:
- Spanish system → Used "APLICACIONES", "DOCUMENTOS", etc.
- English system → Used "APPLICATIONS", "DOCUMENTS", etc.

### Why This Failed
macOS Spotlight **always** uses English internal keys, regardless of the display language. The system translates these keys for UI display, but the preference keys themselves are never localized.

### The Fix
```bash
# Always use English keys
defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 1;"name" = "APPLICATIONS";}' \    # ✅ Always works
    '{"enabled" = 1;"name" = "DOCUMENTS";}' \       # ✅ Always works
    '{"enabled" = 1;"name" = "DIRECTORIES";}'       # ✅ Always works
```

## Examples

### Example 1: Quick Development Setup
```bash
# Install just the essentials for coding
cd modular
./bootstrap-modular.sh homebrew zsh asdf developer
```

### Example 2: System Preferences Only
```bash
# Configure macOS settings without installing apps
cd modular
./bootstrap-modular.sh keyboard finder spotlight developer
```

### Example 3: Disable Spotlight on Enhanced Version
```bash
# Run everything except Spotlight
./bootstrap.sh
./macos-preferences.sh --no-spotlight
```

### Example 4: Customize Language Versions
```bash
# Edit config.sh
NODEJS_VERSIONS=("22.0.0" "20.10.0" "18.4.0")
PYTHON_VERSIONS=("3.12.0" "3.10.0")

# Run only ASDF module
./bootstrap-modular.sh asdf
```

## Troubleshooting

### Spotlight Still Not Working
If Spotlight configuration still fails:
1. Check current Spotlight settings:
   ```bash
   defaults read com.apple.spotlight orderedItems
   ```
2. Note the category names used (they should be English)
3. Rebuild Spotlight index:
   ```bash
   sudo mdutil -E /
   ```

### Module Not Found (Modular Version)
Ensure all module files are executable:
```bash
chmod +x modular/modules/*.sh
```

### Config Not Loading (Modular Version)
Check that `config.sh` is in the same directory as `bootstrap-modular.sh`:
```bash
ls -l modular/
# Should show: bootstrap-modular.sh config.sh modules/
```

## Contributing

When adding new features:
1. **Enhanced Version**: Add feature toggle at top of file, wrap section in if statement
2. **Modular Version**: Create new module in `modules/`, add config option to `config.sh`, add to orchestrator

## License

Same as original - provided as-is for educational and practical use.
