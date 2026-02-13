#!/bin/bash
# ============================================================
# ZSH MODULE
# ============================================================

# Install Zsh
if [ "$INSTALL_ZSH" = true ]; then
    if ! command -v zsh >/dev/null 2>&1; then
        echo "Installing Zsh..."
        brew install zsh
        echo "✅ Zsh installed"
    else
        echo "✅ Zsh already installed"
    fi

    # Set as default shell
    if [[ "$SHELL" != *"zsh"* ]]; then
        echo "Setting Zsh as default shell..."
        chsh -s "$(which zsh)"
        echo "✅ Zsh set as default shell"
    fi
fi

# Install Oh My Zsh
if [ "$INSTALL_OH_MY_ZSH" = true ]; then
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh..."
        RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        echo "✅ Oh My Zsh installed"
    else
        echo "✅ Oh My Zsh already installed"
    fi
fi

# Install Zsh Plugins
if [ "$INSTALL_ZSH_PLUGINS" = true ]; then
    ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    install_plugin() {
        local url="$1"
        local dir="$ZSH_CUSTOM_DIR/plugins/$(basename "$url" .git)"

        if [ ! -d "$dir" ]; then
            echo "Installing $(basename "$url" .git)..."
            git clone "$url" "$dir" --quiet
            echo "✅ $(basename "$url" .git) installed"
        else
            echo "✅ $(basename "$url" .git) already installed"
        fi
    }

    install_plugin https://github.com/zsh-users/zsh-syntax-highlighting.git
    install_plugin https://github.com/zsh-users/zsh-autosuggestions.git
fi

# Apply custom .zshrc
if [ "$APPLY_CUSTOM_ZSHRC" = true ] && [ -n "${ZSHRC_URL:-}" ]; then
    echo "Applying custom Zsh configuration from ${ZSHRC_URL}..."
    curl -fsSL "$ZSHRC_URL" > ~/.zshrc
    echo "✅ Custom .zshrc applied"
fi
