#!/bin/bash
# ============================================================
# KEYBOARD & MOUSE MODULE
# ============================================================

echo "⌨️  Configuring keyboard and mouse..."

defaults write -g InitialKeyRepeat -int "${KEY_REPEAT_INITIAL:-35}"
defaults write -g KeyRepeat -int "${KEY_REPEAT_RATE:-2}"
defaults write -g com.apple.mouse.scaling "${MOUSE_SCALING:-2.0}"
defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode TwoButton

echo "✅ Keyboard and mouse configured"
