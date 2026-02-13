# Modular macOS Bootstrap

A flexible, modular approach to automating macOS setup with individual, reusable components.

## Quick Start

```bash
# 1. Configure your preferences
vim config.sh

# 2. Run the bootstrap
./bootstrap-modular.sh

# Or run specific modules only
./bootstrap-modular.sh homebrew zsh docker
```

## Structure

```
modular/
├── bootstrap-modular.sh    # Main orchestrator
├── config.sh               # Configuration file
└── modules/                # Individual components
    ├── xcode-cli.sh
    ├── homebrew.sh
    ├── zsh.sh
    ├── keyboard.sh
    ├── language.sh
    ├── dock.sh
    ├── finder.sh
    ├── spotlight.sh
    ├── developer.sh
    ├── security.sh
    ├── safari.sh
    ├── sleep.sh
    ├── docker.sh
    ├── asdf.sh
    ├── applications.sh
    └── default-browser.sh
```

## Configuration

Edit `config.sh` to customize all settings in one place:

```bash
# Enable/disable features
INSTALL_HOMEBREW=true
CONFIGURE_DOCK=true
INSTALL_ASDF=true

# Customize settings
KEY_REPEAT_INITIAL=35
MOUSE_SCALING=2.0
SYSTEM_LANGUAGE="es-ES"

# Specify versions
NODEJS_VERSIONS=("20.10.0" "18.4.0")
PYTHON_VERSIONS=("3.10.0" "3.6.12")

# Custom URLs
ZSHRC_URL="https://gist.githubusercontent.com/YourUsername/zshrc/raw"
BREWFILE_URL="https://gist.githubusercontent.com/YourUsername/brewfile/raw"
```

## Usage

### Run All Enabled Modules
```bash
./bootstrap-modular.sh
```

### Run Specific Modules
```bash
./bootstrap-modular.sh homebrew zsh docker
```

### List Available Modules
```bash
./bootstrap-modular.sh --list
```

### Common Workflows

**Development Setup:**
```bash
./bootstrap-modular.sh homebrew zsh asdf developer
```

**System Preferences Only:**
```bash
./bootstrap-modular.sh keyboard dock finder spotlight developer
```

**Minimal Setup:**
```bash
./bootstrap-modular.sh homebrew zsh keyboard finder developer
```

## Available Modules

### Core Tools
- **xcode-cli** - Install Xcode Command Line Tools
- **homebrew** - Install Homebrew package manager

### Shell
- **zsh** - Install Zsh, Oh My Zsh, and plugins

### macOS Preferences
- **keyboard** - Configure keyboard and mouse settings
- **language** - Set system language
- **dock** - Configure Dock appearance and pinned apps
- **finder** - Configure Finder settings
- **spotlight** - Configure Spotlight search categories
- **developer** - Configure developer-friendly settings (no auto-correct, expanded panels, etc.)
- **security** - Enable security features (firewall, Gatekeeper, passwords)
- **safari** - Configure Safari security settings
- **sleep** - Configure power management (disable sleep)

### Applications & Services
- **docker** - Install and configure Docker for always-on services
- **asdf** - Install ASDF version manager and language runtimes
- **git** - Configure Git global settings (default branch, aliases, gitignore)
- **applications** - Install applications from Brewfile
- **default-browser** - Set Chrome as default browser

## Benefits

1. **Single Configuration File** - All settings in `config.sh`
2. **Modular Design** - Each feature in its own file
3. **Easy to Reference** - Quickly find and modify specific settings
4. **Selective Execution** - Run only what you need
5. **Reusable Components** - Import modules into other scripts
6. **Independent Testing** - Test each module separately

## Customization Examples

### Add Custom Apps to Dock
Edit `config.sh`:
```bash
DOCK_APPS=(
    "/Applications/Google Chrome.app:Google Chrome"
    "/Applications/Visual Studio Code.app:VS Code"
    "/Applications/Slack.app:Slack"
)
```

### Change Keyboard Settings
Edit `config.sh`:
```bash
KEY_REPEAT_INITIAL=20  # Faster repeat (lower = faster)
KEY_REPEAT_RATE=1      # Very fast repeat rate
MOUSE_SCALING=3.0      # Higher mouse acceleration
```

### Add More Node.js Versions
Edit `config.sh`:
```bash
NODEJS_VERSIONS=("22.0.0" "20.10.0" "18.4.0" "16.20.0")
```

### Use Your Own Brewfile
Edit `config.sh`:
```bash
BREWFILE_URL="https://raw.githubusercontent.com/YourUsername/dotfiles/main/Brewfile"
```

### Configure Git Identity
Edit `config.sh`:
```bash
GIT_USER_NAME="Your Name"
GIT_USER_EMAIL="your@email.com"
GIT_DEFAULT_BRANCH="main"
GIT_PULL_REBASE=true
```

## Module Development

To create a new module:

1. Create file in `modules/`:
```bash
touch modules/my-feature.sh
chmod +x modules/my-feature.sh
```

2. Add configuration to `config.sh`:
```bash
CONFIGURE_MY_FEATURE=true
MY_FEATURE_SETTING="value"
```

3. Implement module:
```bash
#!/bin/bash
# MY FEATURE MODULE

echo "Configuring my feature..."

# Use config variables
if [ "$CONFIGURE_MY_FEATURE" = true ]; then
    # Do something with MY_FEATURE_SETTING
    echo "✅ My feature configured"
fi
```

4. Add to orchestrator in `bootstrap-modular.sh`:
```bash
[ "$CONFIGURE_MY_FEATURE" = true ] && run_module "my-feature"
```

## Spotlight Configuration Note

Spotlight category names are **always in English** internally, regardless of system language. The system translates them for UI display, but the preference keys are never localized.

✅ Correct:
```bash
'{"enabled" = 1;"name" = "APPLICATIONS";}'
```

❌ Incorrect:
```bash
'{"enabled" = 1;"name" = "APLICACIONES";}'  # Won't work even on Spanish systems
```

## Troubleshooting

### Modules Not Running
Check that all scripts are executable:
```bash
chmod +x bootstrap-modular.sh modules/*.sh
```

### Config Not Loading
Ensure `config.sh` is in the same directory as `bootstrap-modular.sh`.

### Module Errors
Run individual modules to isolate issues:
```bash
./bootstrap-modular.sh problematic-module
```

## See Also

- [../IMPROVEMENTS.md](../IMPROVEMENTS.md) - Detailed changelog and improvements
- [../README.md](../README.md) - Original bootstrap documentation
- [../bootstrap.sh](../bootstrap.sh) - Enhanced monolithic version with feature toggles

## Differences from Enhanced Version

| Feature | Enhanced Version | Modular Version |
|---------|-----------------|-----------------|
| Structure | Single/dual files | Multiple module files |
| Configuration | Command-line flags | Central config file |
| Customization | Edit script directly | Edit config.sh |
| Selective Execution | Via flags | Via module names |
| Best For | Simple setups | Complex/custom setups |

## License

Provided as-is for educational and practical use.
