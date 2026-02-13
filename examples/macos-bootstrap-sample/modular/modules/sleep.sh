#!/bin/bash
# ============================================================
# POWER/SLEEP MANAGEMENT MODULE
# ============================================================

echo "⚡ Configuring power management..."

# Disable display sleep (0 = never)
sudo pmset -a displaysleep 0 2>/dev/null || echo "  ⚠️  Requires admin"

# Disable system sleep
sudo pmset -a sleep 0 2>/dev/null || echo "  ⚠️  Requires admin"

# Disable screen saver
defaults -currentHost write com.apple.screensaver idleTime 0

echo "✅ Display configured to never sleep"
echo "  ℹ️  To re-enable: sudo pmset -a displaysleep 10"
