#!/bin/bash
# ============================================================
# LANGUAGE MODULE
# ============================================================

echo "🌐 Setting system language to ${SYSTEM_LANGUAGE}..."
defaults write -g AppleLanguages -array "${SYSTEM_LANGUAGE}" 2>/dev/null || true
echo "✅ Language set to ${SYSTEM_LANGUAGE}"
