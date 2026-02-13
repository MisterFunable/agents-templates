#!/bin/bash
# ============================================================
# DOCKER MODULE
# ============================================================

echo "🐳 Configuring Docker..."

# Install Docker via Homebrew
if ! brew list --cask 2>/dev/null | grep -q "^docker$"; then
    echo "Installing Docker..."
    brew install --cask docker
else
    echo "✅ Docker already installed"
fi

if command -v docker >/dev/null 2>&1 || [ -d "/Applications/Docker.app" ]; then
    # Create Docker config directory
    mkdir -p "$HOME/.docker"

    # Create daemon.json with optimal settings
    cat > "$HOME/.docker/daemon.json" << EOF
{
  "debug": false,
  "experimental": false,
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "${DOCKER_LOG_MAX_SIZE:-10m}",
    "max-file": "${DOCKER_LOG_MAX_FILES:-3}"
  },
  "storage-driver": "overlay2",
  "builder": {
    "gc": {
      "enabled": true,
      "defaultKeepStorage": "${DOCKER_KEEP_STORAGE:-20GB}"
    }
  }
}
EOF

    echo "✅ Docker daemon configuration created"
    echo "  ℹ️  Log rotation: ${DOCKER_LOG_MAX_SIZE:-10m} max, ${DOCKER_LOG_MAX_FILES:-3} files"
    echo "  ℹ️  Garbage collection: keeps ${DOCKER_KEEP_STORAGE:-20GB}"

    # Set Docker to start on login
    if [ -d "/Applications/Docker.app" ] && [ "${SETUP_LOGIN_ITEMS:-true}" = true ]; then
        echo "Setting Docker to start on login..."
        osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/Docker.app", hidden:false}' 2>/dev/null || true
        echo "✅ Docker will start on login"
    fi
else
    echo "ℹ️  Docker not found"
fi
