#!/bin/bash
# ============================================================
# XCODE COMMAND LINE TOOLS MODULE
# ============================================================

echo "Checking for Xcode Command Line Tools..."
if ! xcode-select -p &>/dev/null; then
    echo "⚠️  Xcode Command Line Tools not installed."
    echo "📦 Installing Xcode Command Line Tools..."
    echo ""
    echo "A dialog will appear. Please click 'Install' and wait for completion."
    echo "After installation completes, run this script again."
    echo ""
    xcode-select --install
    echo ""
    echo "❌ Exiting. Please run this script again after Xcode Command Line Tools installation completes."
    exit 1
else
    echo "✅ Xcode Command Line Tools already installed"
fi
