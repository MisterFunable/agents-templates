#!/bin/bash
# ============================================================
# DOCK MODULE
# ============================================================

echo "🚀 Configuring Dock..."

# Helper function to add app to Dock
ensure_dock_app() {
    local app_path="$1"
    local label="$2"

    if [ ! -d "$app_path" ]; then
        echo "  ℹ️  ${label} not found at ${app_path}; skipping"
        return 0
    fi

    if defaults read com.apple.dock persistent-apps 2>/dev/null | grep -Fq "$app_path"; then
        echo "  ✅ ${label} already pinned"
        return 0
    fi

    echo "  Pinning ${label}..."
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

# Helper function to add Downloads folder
ensure_dock_downloads() {
    local downloads_dir="$HOME/Downloads/"
    local downloads_url="file://$downloads_dir"
    mkdir -p "$downloads_dir"

    if defaults read com.apple.dock persistent-others 2>/dev/null | grep -Fq "$downloads_url"; then
        echo "  ✅ Downloads already in Dock"
        return 0
    fi

    echo "  Adding Downloads folder..."
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

# Configure Dock settings
defaults write com.apple.dock static-only -bool false
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock expose-animation-duration -float 0.1

# Pin apps from configuration
if [ -n "${DOCK_APPS:-}" ]; then
    for entry in "${DOCK_APPS[@]}"; do
        IFS=':' read -r app_path app_name <<< "$entry"
        ensure_dock_app "$app_path" "$app_name"
    done
fi

# Add Downloads folder
ensure_dock_downloads

# Restart Dock
killall Dock 2>/dev/null || true

echo "✅ Dock configured"
