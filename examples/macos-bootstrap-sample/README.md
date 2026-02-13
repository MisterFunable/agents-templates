# macOS Bootstrap Script Example

This example demonstrates automated macOS setup with two versions:

1. **Enhanced Version** (`bootstrap.sh` + `macos-preferences.sh`) - Feature toggles via command-line flags
2. **Modular Version** (`modular/`) - Separate files for each component with central configuration

## What's New

- ✅ **Fixed Spotlight Configuration** - Spotlight ordering now works correctly
- ✅ **Feature Toggles** - Enable/disable features without editing code
- ✅ **Modular Structure** - Split into reusable, independent modules
- ✅ **Central Configuration** - Single config file for all settings (modular version)

See [IMPROVEMENTS.md](IMPROVEMENTS.md) for detailed changes.

## Overview

Both versions automate the setup of a new macOS machine with:

- **System Preferences**: Keyboard, mouse, language settings
- **Finder Configuration**: Show extensions, hidden files, path bar
- **Dock Optimization**: Downloads folder as fan view, sorted by date created
- **Security Settings**: Firewall, Gatekeeper, HTTPS enforcement in Safari
- **Development Tools**: Homebrew, ASDF, multiple language runtimes
- **Shell Setup**: Zsh with Oh My Zsh and useful plugins
- **Applications**: GUI apps installed via Homebrew Cask

## Which Version Should I Use?

### Enhanced Version (Recommended for Most Users)
```bash
./bootstrap.sh              # Full setup
./bootstrap.sh --minimal    # Minimal setup
./bootstrap.sh --no-docker  # Custom setup
```

**Use if you want:**
- Simple, traditional script structure
- Command-line flags for quick customization
- Minimal changes from original

### Modular Version (Recommended for Advanced Users)
```bash
cd modular
vim config.sh                            # Customize settings
./bootstrap-modular.sh                   # Full setup
./bootstrap-modular.sh homebrew zsh      # Specific modules
```

**Use if you want:**
- Maximum flexibility and customization
- Easy-to-reference separate component files
- Reusable modules for other projects
- Central configuration file

## Quick Start

### Enhanced Version
```bash
# Run with default settings
./bootstrap.sh

# Skip Docker and ASDF
./bootstrap.sh --no-docker --no-asdf

# System preferences only
./macos-preferences.sh

# Get help
./bootstrap.sh --help
```

### Modular Version
```bash
# Edit configuration
vim modular/config.sh

# Run all enabled modules
cd modular && ./bootstrap-modular.sh

# Run specific modules only
./bootstrap-modular.sh homebrew zsh developer

# List available modules
./bootstrap-modular.sh --list
```

### From Fresh macOS Install (Enhanced Version)

1. Open Terminal
2. Download and run:

```bash
curl -fsSL https://raw.githubusercontent.com/YourUsername/repo/main/bootstrap.sh | bash
```

Or for more control:

```bash
# Download
curl -fsSL https://raw.githubusercontent.com/YourUsername/repo/main/bootstrap.sh -o bootstrap.sh
curl -fsSL https://raw.githubusercontent.com/YourUsername/repo/main/macos-preferences.sh -o macos-preferences.sh

# Make executable
chmod +x bootstrap.sh macos-preferences.sh

# Review
less bootstrap.sh

# Run
./bootstrap.sh
```

## What Gets Configured

### System Settings

- **Keyboard**: Fast key repeat (InitialKeyRepeat=15, KeyRepeat=2)
- **Mouse**: Acceleration set to 2.0, secondary click enabled
- **Language**: Respects existing language, configures Spotlight accordingly
- **Security**: Password required immediately after sleep

### Finder

- Hidden files visible
- All file extensions shown
- Path bar and status bar enabled
- Folders sorted first
- No .DS_Store files on network/USB volumes
- List view as default

### Dock

- Downloads folder added with:
  - Fan view (showas=1)
  - Sorted by date created (arrangement=4)
  - Displayed as folder (displayas=1)
- Static apps only
- Recent applications hidden
- Auto-hide enabled (optional)

### Security

- **Gatekeeper**: Enabled (allows App Store + identified developers)
- **Firewall**: Enabled with stealth mode
- **Safari**: HTTPS upgrade, fraudulent website warnings, pop-up blocking
- **Remote Services**: Apple Events disabled, wake-on-network disabled
- **Guest User**: Disabled

### Developer Tools

- **Homebrew**: Package manager for macOS
- **ASDF**: Version manager for multiple runtimes
  - Node.js: 18.20.0, 20.10.0
  - Python: 3.10.0, 3.6.12
  - Ruby: 2.6.5, 3.4.1
  - Go: 1.15.8
- **Zsh Plugins**:
  - zsh-syntax-highlighting
  - zsh-autosuggestions
- **Applications**: Installed from Brewfile (customizable)

## Customization

### Modify System Settings

Edit the system configuration section to adjust keyboard/mouse speeds:

```bash
# Slower key repeat
defaults write -g InitialKeyRepeat -int 25
defaults write -g KeyRepeat -int 6
```

### Change Downloads Folder View

Modify the arrangement value:

```bash
# arrangement values:
# 1 = Name
# 2 = Date Added
# 3 = Date Modified
# 4 = Date Created (current)
# 5 = Kind
<key>arrangement</key>
<integer>2</integer>  # Change to Date Added
```

### Add More Applications

Add applications to your Brewfile:

```ruby
# Brewfile
brew "git"
brew "node"
cask "visual-studio-code"
cask "docker"
cask "figma"
cask "spotify"
```

Or install directly in the script:

```bash
brew install --cask \
    visual-studio-code \
    docker \
    figma \
    notion
```

### Add Custom Dotfiles

Replace the gist URL with your own:

```bash
# Download your custom .zshrc
curl -fsSL https://gist.githubusercontent.com/YourUsername/your-zshrc-gist/raw > ~/.zshrc
```

## Common Issues

### "Command not found: brew"

**Solution**: Close and reopen Terminal, or manually add Homebrew to PATH:

```bash
# Apple Silicon
eval "$(/opt/homebrew/bin/brew shellenv)"

# Intel
eval "$(/usr/local/bin/brew shellenv)"
```

### Downloads Folder Not Appearing in Dock

**Solution**: The Dock must be restarted. Run:

```bash
killall Dock
```

If still not working, remove all Downloads entries and add again:

```bash
defaults delete com.apple.dock persistent-others
# Then re-run the Downloads configuration section
```

### Spotlight Categories Not Working

**Issue**: This has been fixed in the new versions!

**Solution**: Spotlight category names are **always in English** internally, regardless of system language. The updated scripts now use the correct English keys:

```bash
# ✅ Correct - works on all systems
'{"enabled" = 1;"name" = "APPLICATIONS";}'

# ❌ Wrong - localized names don't exist
'{"enabled" = 1;"name" = "APLICACIONES";}'
```

If Spotlight still doesn't work after running the script, rebuild the index:
```bash
sudo mdutil -E /
```

### Security Settings Require Admin Password

Some commands require `sudo`:
- Gatekeeper configuration
- Firewall settings
- System setup changes
- Guest user disabling

You'll be prompted for your password when needed.

### ASDF Shims Not Working

**Solution**: Source ASDF in your shell:

```bash
echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ~/.zshrc
source ~/.zshrc
```

Then reshim:

```bash
asdf reshim
```

## Security Considerations

### Review Before Running

Always review bootstrap scripts before execution:

```bash
curl -fsSL <gist-url> | less
```

### What This Script Does With Sudo

The script requires `sudo` for:
- Enabling firewall
- Configuring Gatekeeper
- Disabling remote services
- Disabling guest user
- Rebuilding Spotlight index

### What This Script Doesn't Do

- Never disables System Integrity Protection (SIP)
- Never modifies `/System/` directories
- Never installs unsigned applications
- Never disables Gatekeeper entirely
- Never downloads/installs without verification

## Template Compliance

This example follows all guidelines from `AGENTS_MACOS_BOOTSTRAP.md`:

✅ Error handling with `set -e` and `set -u`  
✅ Idempotent operations (safe to re-run)  
✅ Prerequisite checks  
✅ Language detection  
✅ Service restarts after configuration  
✅ Extensive comments  
✅ Reusable functions  
✅ Feedback messages  
✅ Safe defaults  
✅ Proper `defaults` usage  
✅ Security-conscious settings  

## Next Steps

After running the bootstrap script:

1. **Logout and login** to apply all system preferences
2. **Configure Git** with your credentials:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your@email.com"
   ```
3. **Generate SSH key** for GitHub/GitLab:
   ```bash
   ssh-keygen -t ed25519 -C "your@email.com"
   pbcopy < ~/.ssh/id_ed25519.pub
   # Paste into GitHub: https://github.com/settings/keys
   ```
4. **Install additional tools** specific to your workflow
5. **Configure VS Code** with your extensions and settings
6. **Set up cloud storage** (iCloud, Dropbox, etc.)

## Further Reading

- [AGENTS_MACOS_BOOTSTRAP.md](../../AGENTS_MACOS_BOOTSTRAP.md) - Full template documentation
- [macOS defaults commands](https://macos-defaults.com/) - Comprehensive defaults reference
- [Homebrew Documentation](https://docs.brew.sh/) - Package manager guide
- [ASDF Documentation](https://asdf-vm.com/) - Version manager guide
- [Oh My Zsh](https://ohmyz.sh/) - Zsh framework

## License

This example is provided as-is for educational and practical use. Modify as needed for your setup.

