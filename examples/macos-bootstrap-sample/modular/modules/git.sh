#!/bin/bash
# ============================================================
# GIT GLOBAL CONFIGURATION MODULE
# ============================================================

echo "🔧 Configuring Git global settings..."

# Check if git is installed (should be via Xcode CLI or Homebrew)
if ! command -v git >/dev/null 2>&1; then
    echo "⚠️  Git not found. Installing via Homebrew..."
    brew install git
fi

# Set default branch name
git config --global init.defaultBranch "${GIT_DEFAULT_BRANCH:-main}"
echo "  ✓ Default branch set to '${GIT_DEFAULT_BRANCH:-main}'"

# Set pull strategy
git config --global pull.rebase "${GIT_PULL_REBASE:-true}"
echo "  ✓ Pull strategy set to rebase: ${GIT_PULL_REBASE:-true}"

# Set push default
git config --global push.default "${GIT_PUSH_DEFAULT:-simple}"
echo "  ✓ Push default set to ${GIT_PUSH_DEFAULT:-simple}"

# Automatically setup remote branch tracking
git config --global push.autoSetupRemote true
echo "  ✓ Auto setup remote branch tracking enabled"

# Use diff3 conflict style (shows common ancestor)
git config --global merge.conflictstyle diff3
echo "  ✓ Merge conflict style set to diff3"

# Enable rerere (reuse recorded resolution)
git config --global rerere.enabled "${GIT_RERERE_ENABLED:-true}"
echo "  ✓ Rerere (reuse recorded resolution) enabled: ${GIT_RERERE_ENABLED:-true}"

# Prune remote branches on fetch
git config --global fetch.prune "${GIT_FETCH_PRUNE:-true}"
echo "  ✓ Auto-prune remote branches on fetch: ${GIT_FETCH_PRUNE:-true}"

# Use more readable diffs
git config --global diff.algorithm histogram
echo "  ✓ Diff algorithm set to histogram"

# Colorize output
git config --global color.ui auto
echo "  ✓ Colorized output enabled"

# Show original branch names on merge conflicts
git config --global merge.conflictStyle diff3
echo "  ✓ Show original branch names in conflicts"

# Rebase by default when pulling
git config --global branch.autoSetupRebase always
echo "  ✓ Auto-rebase on pull for all branches"

# Configure Git aliases if enabled
if [ "${GIT_CONFIGURE_ALIASES:-true}" = true ]; then
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.st status
    git config --global alias.unstage 'reset HEAD --'
    git config --global alias.last 'log -1 HEAD'
    git config --global alias.visual 'log --oneline --graph --decorate --all'
    git config --global alias.amend 'commit --amend --no-edit'
    echo "  ✓ Git aliases configured (co, br, ci, st, unstage, last, visual, amend)"
fi

# Better diff for moved lines
git config --global diff.colorMoved zebra
echo "  ✓ Better diff for moved lines"

# Set default editor
if [ -n "${GIT_EDITOR:-}" ]; then
    git config --global core.editor "$GIT_EDITOR"
    echo "  ✓ Git editor set to $GIT_EDITOR"
elif [ -n "${EDITOR:-}" ]; then
    git config --global core.editor "$EDITOR"
    echo "  ✓ Git editor set to $EDITOR"
elif command -v code >/dev/null 2>&1; then
    git config --global core.editor "code --wait"
    echo "  ✓ Git editor set to VS Code"
else
    git config --global core.editor vim
    echo "  ✓ Git editor set to vim"
fi

# Store credentials securely (macOS Keychain)
git config --global credential.helper osxkeychain
echo "  ✓ Credential helper set to macOS Keychain"

# Better handling of whitespace
git config --global core.whitespace trailing-space,space-before-tab
echo "  ✓ Whitespace handling configured"

# Exclude common files globally
GLOBAL_GITIGNORE="${GIT_GLOBAL_GITIGNORE:-$HOME/.gitignore_global}"
if [ ! -f "$GLOBAL_GITIGNORE" ]; then
    cat > "$GLOBAL_GITIGNORE" << 'EOF'
# macOS
.DS_Store
.AppleDouble
.LSOverride
Icon

# Thumbnails
._*

# Files that might appear in the root of a volume
.DocumentRevisions-V100
.fseventsd
.Spotlight-V100
.TemporaryItems
.Trashes
.VolumeIcon.icns
.com.apple.timemachine.donotpresent

# Directories potentially created on remote AFP share
.AppleDB
.AppleDesktop
Network Trash Folder
Temporary Items
.apdisk

# Editor files
*.swp
*.swo
*~
.vscode/
.idea/

# Node
node_modules/
npm-debug.log*

# Python
__pycache__/
*.py[cod]
.Python
venv/
.env

# Other
.env.local
.env.*.local
EOF
    git config --global core.excludesfile "$GLOBAL_GITIGNORE"
    echo "  ✓ Global gitignore created at $GLOBAL_GITIGNORE"
else
    echo "  ✓ Global gitignore already exists at $GLOBAL_GITIGNORE"
fi

# Configure Git identity if provided
if [ -n "${GIT_USER_NAME:-}" ] && [ -n "${GIT_USER_EMAIL:-}" ]; then
    git config --global user.name "$GIT_USER_NAME"
    git config --global user.email "$GIT_USER_EMAIL"
    echo "  ✓ Git identity configured: $GIT_USER_NAME <$GIT_USER_EMAIL>"
else
    echo ""
    echo "ℹ️  NOTE: You still need to configure your Git identity:"
    echo "   git config --global user.name \"Your Name\""
    echo "   git config --global user.email \"your@email.com\""
fi

echo ""
echo "✅ Git global configuration complete"
