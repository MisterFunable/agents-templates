#!/bin/bash
# ============================================================
# MACOS PREFERENCES (No package dependencies required)
# ============================================================
# This script configures macOS system preferences using only
# built-in macOS commands (defaults, killall, pmset, etc.).
# Can be run standalone or sourced from bootstrap.sh.
#
# Usage:
#   ./macos-preferences.sh                 # Run all settings
#   ./macos-preferences.sh --no-sleep      # Skip power/sleep settings
#   ./macos-preferences.sh --no-spotlight  # Skip Spotlight configuration
#   ./macos-preferences.sh --minimal       # Skip dock, spotlight, security
# ============================================================

set -e
set -u

# ============================================================
# FEATURE TOGGLES
# ============================================================
CONFIGURE_KEYBOARD_MOUSE=true
CONFIGURE_LANGUAGE=true
CONFIGURE_DOCK=true
CONFIGURE_FINDER=true
CONFIGURE_SPOTLIGHT=true
CONFIGURE_DEVELOPER=true
CONFIGURE_SECURITY=true
CONFIGURE_SAFARI=true
CONFIGURE_SLEEP=true

# Parse arguments
for arg in "$@"; do
  case "$arg" in
    --no-sleep) CONFIGURE_SLEEP=false ;;
    --no-keyboard) CONFIGURE_KEYBOARD_MOUSE=false ;;
    --no-language) CONFIGURE_LANGUAGE=false ;;
    --no-dock) CONFIGURE_DOCK=false ;;
    --no-finder) CONFIGURE_FINDER=false ;;
    --no-spotlight) CONFIGURE_SPOTLIGHT=false ;;
    --no-developer) CONFIGURE_DEVELOPER=false ;;
    --no-security) CONFIGURE_SECURITY=false ;;
    --no-safari) CONFIGURE_SAFARI=false ;;
    --minimal) CONFIGURE_DOCK=false; CONFIGURE_SPOTLIGHT=false; CONFIGURE_SECURITY=false; CONFIGURE_SLEEP=false ;;
    --help)
      echo "macOS Preferences Configuration Script"
      echo ""
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --no-keyboard    Skip keyboard and mouse configuration"
      echo "  --no-language    Skip language configuration"
      echo "  --no-dock        Skip Dock configuration"
      echo "  --no-finder      Skip Finder configuration"
      echo "  --no-spotlight   Skip Spotlight configuration"
      echo "  --no-developer   Skip developer settings"
      echo "  --no-security    Skip security settings"
      echo "  --no-safari      Skip Safari configuration"
      echo "  --no-sleep       Skip power/sleep settings"
      echo "  --minimal        Apply only basic settings (keyboard, finder, developer)"
      echo "  --help           Show this help message"
      exit 0
      ;;
  esac
done

echo ""
echo "⚙️  Configuring macOS system preferences..."
echo "============================================"

# ============================================================
# HELPER FUNCTIONS (Dock manipulation)
# ============================================================

ensure_dock_downloads_stack() {
  local downloads_dir="$HOME/Downloads/"
  local downloads_url="file://$downloads_dir"
  mkdir -p "$downloads_dir"

  # Clean broken/ghost Dock stack entries (e.g. _CFURLString = "file://")
  {
    tmp_plist="$(mktemp /tmp/com.apple.dock.XXXXXX.plist)"
    defaults export com.apple.dock "$tmp_plist" 2>/dev/null || true
    /usr/bin/python3 - "$tmp_plist" <<'PY' || true
import plistlib, sys
path = sys.argv[1]
with open(path, "rb") as f:
    data = plistlib.load(f)
others = data.get("persistent-others")
if isinstance(others, list):
    cleaned = []
    for item in others:
        try:
            url = item.get("tile-data", {}).get("file-data", {}).get("_CFURLString")
        except Exception:
            url = None
        if url in (None, "", "file://"):
            continue
        cleaned.append(item)
    if len(cleaned) != len(others):
        data["persistent-others"] = cleaned
        with open(path, "wb") as f:
            plistlib.dump(data, f)
PY
    defaults import com.apple.dock "$tmp_plist" 2>/dev/null || true
    rm -f "$tmp_plist"
  } || true

  if defaults read com.apple.dock persistent-others 2>/dev/null | grep -Fq "$downloads_url"; then
    echo "  ✅ Downloads already present in Dock"
    return 0
  fi

  echo "  Adding Downloads to Dock (Stack + Fan + Date Created)..."
  defaults write com.apple.dock persistent-others -array-add '{
    "tile-data" = {
      "file-data" = {
        "_CFURLString" = "'"$downloads_url"'";
        "_CFURLStringType" = 15;
      };
      arrangement = 4;
      displayas = 0;
      showas = 1;
    };
    "tile-type" = "directory-tile";
  }'
}

ensure_dock_app() {
  local app_path="$1"
  local label="$2"

  if [ ! -d "$app_path" ]; then
    echo "  ℹ️  ${label} not found at ${app_path}; skipping"
    return 0
  fi

  if defaults read com.apple.dock persistent-apps 2>/dev/null | grep -Fq "$app_path"; then
    echo "  ✅ ${label} already pinned in Dock"
    return 0
  fi

  echo "  Pinning ${label} to Dock..."
  defaults write com.apple.dock persistent-apps -array-add "
    <dict>
      <key>tile-data</key>
      <dict>
        <key>file-data</key>
        <dict>
          <key>_CFURLString</key>
          <string>file://$app_path</string>
          <key>_CFURLStringType</key>
          <integer>15</integer>
        </dict>
      </dict>
      <key>tile-type</key>
      <string>file-tile</string>
    </dict>
  "
}

ensure_dock_calendar() {
  if [ -d "/System/Applications/Calendar.app" ]; then
    ensure_dock_app "/System/Applications/Calendar.app" "Calendar"
  else
    ensure_dock_app "/Applications/Calendar.app" "Calendar"
  fi
}

# ============================================================
# KEYBOARD & MOUSE
# ============================================================
if [ "$CONFIGURE_KEYBOARD_MOUSE" = true ]; then
    echo ""
    echo "⌨️  Keyboard and mouse configurations..."

    defaults write -g InitialKeyRepeat -int 35
    defaults write -g KeyRepeat -int 2
    defaults write -g com.apple.mouse.scaling 2.0
    defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode TwoButton

    echo "  ✅ Keyboard repeat and mouse settings configured"
fi

# ============================================================
# LANGUAGE (optional - comment out if you prefer English)
# ============================================================
if [ "$CONFIGURE_LANGUAGE" = true ]; then
    echo ""
    echo "🌐 Setting language to Spanish..."
    defaults write -g AppleLanguages -array "es-ES" 2>/dev/null || true
    echo "  ✅ Language set to Spanish"
fi

# ============================================================
# DOCK CONFIGURATION
# ============================================================
if [ "$CONFIGURE_DOCK" = true ]; then
    echo ""
    echo "🚀 Configuring Dock..."

    # Show pinned apps (not static-only mode)
    defaults write com.apple.dock static-only -bool false

    # Disable recent/suggested apps
    defaults write com.apple.dock show-recents -bool false

    # Speed up Mission Control animations
    defaults write com.apple.dock expose-animation-duration -float 0.1

    # Pin apps to Dock
    echo "  Pinning apps to Dock..."
    ensure_dock_app "/Applications/Google Chrome.app" "Google Chrome"
    ensure_dock_calendar
    ensure_dock_app "/Applications/iTerm.app" "iTerm"

    # Add Downloads folder
    echo "  Configuring Downloads folder..."
    ensure_dock_downloads_stack

    # Restart Dock to apply changes
    killall Dock 2>/dev/null || true

    echo "  ✅ Dock configured"
fi

# ============================================================
# FINDER CONFIGURATION
# ============================================================
if [ "$CONFIGURE_FINDER" = true ]; then
    echo ""
    echo "📁 Configuring Finder..."

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

    # Enable text selection in Quick Look
    defaults write com.apple.finder QLEnableTextSelection -bool true

    killall Finder 2>/dev/null || true

    echo "  ✅ Finder configured"
fi

# ============================================================
# SPOTLIGHT CONFIGURATION (IMPROVED)
# ============================================================
if [ "$CONFIGURE_SPOTLIGHT" = true ]; then
    echo ""
    echo "🔍 Configuring Spotlight..."

    # Read current Spotlight configuration to detect actual category names
    CURRENT_SPOTLIGHT=$(defaults read com.apple.spotlight orderedItems 2>/dev/null || echo "")

    # Extract the first category name to detect the naming pattern
    # This is more reliable than language detection
    if [ -n "$CURRENT_SPOTLIGHT" ]; then
        # Try to detect if using localized names by checking for common patterns
        if echo "$CURRENT_SPOTLIGHT" | grep -q "APLICACIONES"; then
            echo "  Detected Spanish Spotlight categories"
            USE_SPANISH=true
        elif echo "$CURRENT_SPOTLIGHT" | grep -q "APPLICATIONS"; then
            echo "  Detected English Spotlight categories"
            USE_SPANISH=false
        else
            # Fallback to language detection
            LANGUAGE=$(defaults read -g AppleLanguages 2>/dev/null | head -2 | tail -1 | tr -d ' ",' || echo "en")
            echo "  Could not detect Spotlight language, using system language: $LANGUAGE"
            [[ "$LANGUAGE" == es* ]] && USE_SPANISH=true || USE_SPANISH=false
        fi
    else
        # No existing config, use language detection
        LANGUAGE=$(defaults read -g AppleLanguages 2>/dev/null | head -2 | tail -1 | tr -d ' ",' || echo "en")
        echo "  No existing Spotlight config, using system language: $LANGUAGE"
        [[ "$LANGUAGE" == es* ]] && USE_SPANISH=true || USE_SPANISH=false
    fi

    if [ "$USE_SPANISH" = true ]; then
        echo "  Setting Spotlight order for Spanish..."
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

    # Reload Spotlight preferences
    killall Spotlight 2>/dev/null || true

    echo "  ✅ Spotlight configured"
    echo "  ℹ️  Note: The category names are NOT language-specific."
    echo "     macOS uses English keys internally regardless of system language."
fi

# ============================================================
# DEVELOPER & PRODUCTIVITY SETTINGS
# ============================================================
if [ "$CONFIGURE_DEVELOPER" = true ]; then
    echo ""
    echo "💻 Configuring developer and productivity settings..."

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

    echo "  ✅ Developer settings configured"
fi

# ============================================================
# SECURITY SETTINGS
# ============================================================
if [ "$CONFIGURE_SECURITY" = true ]; then
    echo ""
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

    echo "  ✅ Security settings configured"
fi

# ============================================================
# SAFARI SETTINGS (built-in browser)
# ============================================================
if [ "$CONFIGURE_SAFARI" = true ]; then
    echo ""
    echo "🌐 Configuring Safari..."

    if pgrep -x "Safari" > /dev/null; then
        echo "  ⚠️  Safari is running. Some settings may not apply until restarted."
    fi

    {
        defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true 2>/dev/null || true
        defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false 2>/dev/null || true
        defaults write com.apple.Safari \
            com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false 2>/dev/null || true
        defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true 2>/dev/null || true
        echo "  ✅ Safari security configured"
    } || echo "  ⚠️  Safari settings may require manual configuration"
fi

# ============================================================
# POWER MANAGEMENT & DISPLAY SETTINGS (OPTIONAL)
# ============================================================
if [ "$CONFIGURE_SLEEP" = true ]; then
  echo ""
  echo "⚡ Configuring power management (always-on mode)..."

  # Disable display sleep (0 = never)
  sudo pmset -a displaysleep 0 2>/dev/null || echo "  ⚠️  Requires admin"

  # Disable system sleep
  sudo pmset -a sleep 0 2>/dev/null || echo "  ⚠️  Requires admin"

  # Disable screen saver
  defaults -currentHost write com.apple.screensaver idleTime 0

  echo "  ✅ Display configured to never sleep"
  echo "  ℹ️  To re-enable: sudo pmset -a displaysleep 10"
else
  echo ""
  echo "⚡ Skipping power management settings (--no-sleep flag)"
fi

# ============================================================
# DONE
# ============================================================
echo ""
echo "============================================"
echo "✅ macOS preferences configured!"
echo "============================================"
echo ""
echo "📋 Summary:"
[ "$CONFIGURE_KEYBOARD_MOUSE" = true ] && echo "  • Keyboard/mouse optimized"
[ "$CONFIGURE_LANGUAGE" = true ] && echo "  • Language set to Spanish"
[ "$CONFIGURE_DOCK" = true ] && echo "  • Dock: Chrome, Calendar, iTerm, Downloads (Fan)"
[ "$CONFIGURE_FINDER" = true ] && echo "  • Finder: hidden files, extensions, path bar"
[ "$CONFIGURE_SPOTLIGHT" = true ] && echo "  • Spotlight: prioritized apps/docs"
[ "$CONFIGURE_SECURITY" = true ] && echo "  • Security: firewall, gatekeeper, passwords"
[ "$CONFIGURE_SAFARI" = true ] && echo "  • Safari: security settings enabled"
[ "$CONFIGURE_DEVELOPER" = true ] && echo "  • Developer: expanded panels, no auto-correct"
[ "$CONFIGURE_SLEEP" = true ] && echo "  • Power: display never sleeps"
echo ""
echo "⚠️  Some changes require logout/restart to take effect."

