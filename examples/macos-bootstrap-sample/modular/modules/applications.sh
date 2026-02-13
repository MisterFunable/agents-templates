#!/bin/bash
# ============================================================
# APPLICATIONS MODULE
# ============================================================

echo "📦 Installing applications..."

# Download and install from Brewfile
if [ -n "${BREWFILE_URL:-}" ]; then
    echo "Downloading Brewfile from ${BREWFILE_URL}..."
    curl -fsSL "$BREWFILE_URL" > /tmp/Brewfile
    brew bundle install --file=/tmp/Brewfile --quiet
    rm -f /tmp/Brewfile
else
    echo "  ⚠️  BREWFILE_URL not set in config.sh"
fi

# Helper function to add login items
ensure_login_item() {
    local app_path="$1"
    local app_name="$2"

    if [ ! -d "$app_path" ]; then
        echo "  ℹ️  $app_name not found at $app_path; skipping login item"
        return 0
    fi

    if ! osascript >/dev/null 2>&1 <<EOF
tell application "System Events"
    if not (exists login item "$app_name") then
        make login item at end with properties {name:"$app_name", path:"$app_path", hidden:false}
    end if
end tell
EOF
    then
        echo "  ⚠️  Could not add $app_name as login item"
        return 0
    fi

    echo "  ✅ $app_name will start at login"
}

# Setup login items
if [ "${SETUP_LOGIN_ITEMS:-true}" = true ] && [ -n "${LOGIN_ITEMS:-}" ]; then
    echo "Configuring login items..."
    for entry in "${LOGIN_ITEMS[@]}"; do
        IFS=':' read -r app_path app_name <<< "$entry"
        ensure_login_item "$app_path" "$app_name"
    done
fi

echo "✅ Applications installed"
