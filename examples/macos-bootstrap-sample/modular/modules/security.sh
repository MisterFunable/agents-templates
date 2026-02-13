#!/bin/bash
# ============================================================
# SECURITY SETTINGS MODULE
# ============================================================

echo "🔒 Configuring security settings..."

# Require password immediately after sleep or screen saver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Enable secure keyboard entry in Terminal
defaults write com.apple.terminal SecureKeyboardEntry -bool true

# Enable Gatekeeper (requires admin)
sudo spctl --master-enable 2>/dev/null || echo "  ⚠️  Gatekeeper requires admin"

# Enable firewall (requires admin)
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on 2>/dev/null || true
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on 2>/dev/null || true

# Disable remote Apple events (requires admin)
sudo systemsetup -setremoteappleevents off 2>/dev/null || true

# Disable wake on network access (requires admin)
sudo systemsetup -setwakeonnetworkaccess off 2>/dev/null || true

# Disable guest user (requires admin)
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false 2>/dev/null || true

echo "✅ Security settings configured"
