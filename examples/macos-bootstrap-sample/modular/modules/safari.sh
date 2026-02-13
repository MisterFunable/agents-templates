#!/bin/bash
# ============================================================
# SAFARI MODULE
# ============================================================

echo "🌐 Configuring Safari..."

if pgrep -x "Safari" > /dev/null; then
    echo "  ⚠️  Safari is running. Some settings may not apply until restarted."
fi

{
    defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true 2>/dev/null || true
    defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false 2>/dev/null || true
    defaults write com.apple.Safari \
        com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false 2>/dev/null || true
    defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true 2>/dev/null || true
    echo "✅ Safari security configured"
} || echo "  ⚠️  Safari settings may require manual configuration"
