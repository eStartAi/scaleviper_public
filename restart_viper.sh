#!/bin/bash

echo "🔁 Restarting ScaleViper..."

# Detect environment choice
MODE="current"
if [ "$1" == "sandbox" ]; then
    cp .env.sandbox .env
    echo "🔧 Using SANDBOX environment"
    MODE="SANDBOX"
elif [ "$1" == "live" ]; then
    cp .env.live .env
    echo "🚀 Using LIVE environment"
    MODE="LIVE"
else
    echo "⚠️ No environment specified (sandbox|live). Defaulting to current .env"
fi

# Load Telegram vars
source .env

# Validate env and capture summary
echo "🧪 Validating environment variables..."
SUMMARY=$(python3 validate_env.py)
if [ $? -ne 0 ]; then
    echo "$SUMMARY"
    echo "❌ Environment validation failed. Fix .env before starting."
    exit 1
fi
echo "$SUMMARY"

# Send Telegram restart + summary
if [ "$ENABLE_TELEGRAM_ALERTS" == "true" ]; then
    curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
        -d chat_id="${TELEGRAM_CHAT_ID}" \
        -d parse_mode="HTML" \
        --data-urlencode text="🔄 <b>ScaleViper Restarted</b>%0A<b>Mode:</b> ${MODE}%0A<pre>${SUMMARY}</pre>" >/dev/null
fi

# Kill existing bot
pkill -f "python3 main.py" 2>/dev/null || true

# Restart bot
echo "▶️ Starting ScaleViper..."
source ~/venv/bin/activate
nohup python3 main.py > logs/scaleviper.log 2>&1 &

echo "✅ ScaleViper restarted! (logs: logs/scaleviper.log)"
