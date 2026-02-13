#!/bin/bash
# ============================================================
# CONFIGURATION FILE FOR MODULAR MACOS BOOTSTRAP
# ============================================================
# Edit this file to enable/disable specific features.
# Set to true/false to control what gets installed/configured.
# ============================================================

# ============================================================
# CORE TOOLS
# ============================================================
INSTALL_XCODE_CLI=true
INSTALL_HOMEBREW=true

# ============================================================
# SHELL CONFIGURATION
# ============================================================
INSTALL_ZSH=true
INSTALL_OH_MY_ZSH=true
INSTALL_ZSH_PLUGINS=true
APPLY_CUSTOM_ZSHRC=true

# Custom .zshrc URL (change to your own gist)
ZSHRC_URL="https://gist.githubusercontent.com/LucianoAdonis/cce0307abc1385bc6cdc3671eb3f5821/raw"

# ============================================================
# MACOS SYSTEM PREFERENCES
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

# ============================================================
# APPLICATIONS & SERVICES
# ============================================================
SET_DEFAULT_BROWSER=true
CONFIGURE_DOCKER=true
INSTALL_APPLICATIONS=true
SETUP_LOGIN_ITEMS=true

# Brewfile URL (change to your own gist)
BREWFILE_URL="https://gist.githubusercontent.com/LucianoAdonis/43a43e5b80515abb828ceb1d3dca2258/raw"

# ============================================================
# GIT CONFIGURATION
# ============================================================
CONFIGURE_GIT=true

# Git Settings
GIT_DEFAULT_BRANCH="main"
GIT_PULL_REBASE=true
GIT_PUSH_DEFAULT="simple"
GIT_RERERE_ENABLED=true
GIT_FETCH_PRUNE=true
GIT_CONFIGURE_ALIASES=true

# Optional: Set these to configure git identity automatically
# Leave empty to configure manually later
GIT_USER_NAME=""
GIT_USER_EMAIL=""

# Optional: Custom git editor (leave empty to auto-detect)
GIT_EDITOR=""

# Optional: Custom global gitignore path
GIT_GLOBAL_GITIGNORE="$HOME/.gitignore_global"

# ============================================================
# ASDF & LANGUAGE RUNTIMES
# ============================================================
INSTALL_ASDF=true
INSTALL_ASDF_NODEJS=true
INSTALL_ASDF_PYTHON=true
INSTALL_ASDF_RUBY=true
INSTALL_ASDF_GOLANG=true

# Version specifications
NODEJS_VERSIONS=("20.10.0" "18.4.0" "18.3.0")
PYTHON_VERSIONS=("3.10.0" "3.6.12")
RUBY_VERSIONS=("2.6.5" "3.4.1")
GOLANG_VERSIONS=("1.15.8")

# ============================================================
# KEYBOARD & MOUSE SETTINGS
# ============================================================
KEY_REPEAT_INITIAL=35  # Lower = faster (15-120, default 25)
KEY_REPEAT_RATE=2      # Lower = faster (2-120, default 6)
MOUSE_SCALING=2.0      # Mouse acceleration (1.0-5.0)

# ============================================================
# LANGUAGE SETTINGS
# ============================================================
SYSTEM_LANGUAGE="es-ES"  # Change to "en-US" for English

# ============================================================
# DOCK APPS TO PIN
# ============================================================
DOCK_APPS=(
    "/Applications/Google Chrome.app:Google Chrome"
    "/System/Applications/Calendar.app:Calendar"
    "/Applications/iTerm.app:iTerm"
)

# ============================================================
# LOGIN ITEMS (Apps to start on boot)
# ============================================================
LOGIN_ITEMS=(
    "/Applications/Rectangle.app:Rectangle"
    "/Applications/Clipy.app:Clipy"
    "/Applications/Docker.app:Docker"
)

# ============================================================
# DOCKER CONFIGURATION
# ============================================================
DOCKER_LOG_MAX_SIZE="10m"
DOCKER_LOG_MAX_FILES="3"
DOCKER_KEEP_STORAGE="20GB"
