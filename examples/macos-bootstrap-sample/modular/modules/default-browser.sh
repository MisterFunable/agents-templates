#!/bin/bash
# ============================================================
# DEFAULT BROWSER MODULE
# ============================================================

echo "🌐 Setting default browser..."

if [ -d "/Applications/Google Chrome.app" ]; then
    if ! command -v defaultbrowser >/dev/null 2>&1; then
        echo "Installing defaultbrowser utility..."
        brew install defaultbrowser >/dev/null 2>&1 || true
    fi

    if command -v defaultbrowser >/dev/null 2>&1; then
        defaultbrowser chrome 2>/dev/null || true
        echo "✅ Chrome set as default browser (may require System Settings approval)"
    else
        echo "⚠️  Could not install/run 'defaultbrowser'"
        echo "   Set manually: System Settings → Desktop & Dock → Default web browser"
    fi
else
    echo "ℹ️  Chrome not installed, skipping"
fi
