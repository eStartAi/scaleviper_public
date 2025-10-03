#!/bin/bash

# === Config ===
BACKUP_DIR="backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
TARGET_DIR="$BACKUP_DIR/backup_$TIMESTAMP"

# === Load Telegram vars from .env ===
source <(grep -v '^#' .env | xargs -d '\n')

send_telegram() {
  if [[ "$ENABLE_TELEGRAM_ALERTS" == "true" && -n "$TELEGRAM_BOT_TOKEN" && -n "$TELEGRAM_CHAT_ID" ]]; then
    curl -s -X POST https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage \
      -d chat_id="$TELEGRAM_CHAT_ID" \
      -d text="📦 ScaleViper backup saved: $TARGET_DIR"
  fi
}

# === Handle commands ===
if [[ "$1" == "save" ]]; then
  echo "🔒 Saving backup to $TARGET_DIR"

  mkdir -p "$TARGET_DIR"

  cp .env "$TARGET_DIR/.env"
  cp main.py "$TARGET_DIR/main.py"
  cp trade_logs.db "$TARGET_DIR/trade_logs.db" 2>/dev/null || echo "(ℹ️ trade_logs.db not found)"
  cp -r utils "$TARGET_DIR/" 2>/dev/null || echo "(ℹ️ utils/ not found)"

  echo "✅ Backup complete: $TARGET_DIR"
  send_telegram

elif [[ "$1" == "promote" ]]; then
  TYPE="$2"
  NUM="$3"
  if [[ -z "$TYPE" || -z "$NUM" ]]; then
    echo "❌ Usage: manage_backups.sh promote [main|auto] <num>"
    exit 1
  fi
  echo "🚀 Promoting backup $NUM of type $TYPE (not implemented)"
else
  echo "Usage:"
  echo "  manage_backups.sh save"
  echo "  manage_backups.sh promote main <num>"
  echo "  manage_backups.sh promote auto <num>"
fi
