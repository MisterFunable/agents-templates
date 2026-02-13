#!/bin/bash
# ============================================================
# ASDF MODULE
# ============================================================

echo "🔧 Installing ASDF and language runtimes..."

# Install ASDF
if ! command -v asdf >/dev/null 2>&1; then
    echo "Installing ASDF..."
    brew install asdf

    # Add ASDF to shell
    echo ". $(brew --prefix asdf)/libexec/asdf.sh" >> ~/.zshrc
    source "$(brew --prefix asdf)/libexec/asdf.sh" 2>/dev/null || true

    echo "✅ ASDF installed"
else
    echo "✅ ASDF already installed"
fi

# Helper function to install ASDF plugin and versions
install_asdf_plugin() {
    local name="$1"
    local url="$2"
    shift 2
    local versions=("$@")

    echo "• Installing $name plugin..."
    if ! asdf plugin-list 2>/dev/null | grep -q "^$name$"; then
        asdf plugin add "$name" "$url" 2>/dev/null || echo "  ⚠️  Plugin add failed, may already exist"
    fi

    for version in "${versions[@]}"; do
        if ! asdf list "$name" 2>/dev/null | grep -q "^  $version$"; then
            echo "  Installing $name $version..."
            asdf install "$name" "$version" || echo "  ⚠️  Failed to install $name $version"
        else
            echo "  ✓ $name $version already installed"
        fi
    done

    # Set last version as global
    local last_version="${versions[-1]}"
    asdf global "$name" "$last_version" 2>/dev/null || true
    echo "  ✓ Set $name global version to $last_version"
}

# Install Node.js
if [ "${INSTALL_ASDF_NODEJS:-true}" = true ] && [ -n "${NODEJS_VERSIONS:-}" ]; then
    install_asdf_plugin nodejs https://github.com/asdf-vm/asdf-nodejs.git "${NODEJS_VERSIONS[@]}"
fi

# Install Python
if [ "${INSTALL_ASDF_PYTHON:-true}" = true ] && [ -n "${PYTHON_VERSIONS:-}" ]; then
    ASDF_PYTHON_PATCH_URL="https://github.com/python/cpython/commit/8ea6353.patch?full_index=1"
    install_asdf_plugin python https://github.com/asdf-community/asdf-python.git "${PYTHON_VERSIONS[@]}"

    # Link python to python3
    for version in "${PYTHON_VERSIONS[@]}"; do
        PYTHON_BIN="$HOME/.asdf/installs/python/$version/bin"
        if [ -d "$PYTHON_BIN" ]; then
            ln -sf "$PYTHON_BIN/python3" "$PYTHON_BIN/python"
            echo "  Linked python3 to python for version $version"
        fi
    done
fi

# Install Ruby
if [ "${INSTALL_ASDF_RUBY:-true}" = true ] && [ -n "${RUBY_VERSIONS:-}" ]; then
    install_asdf_plugin ruby https://github.com/asdf-vm/asdf-ruby.git "${RUBY_VERSIONS[@]}"
fi

# Install Golang
if [ "${INSTALL_ASDF_GOLANG:-true}" = true ] && [ -n "${GOLANG_VERSIONS:-}" ]; then
    ASDF_GOLANG_OVERWRITE_ARCH=amd64  # Needed for M1
    install_asdf_plugin golang https://github.com/asdf-community/asdf-golang.git "${GOLANG_VERSIONS[@]}"
fi

echo "✅ ASDF and language runtimes configured"
