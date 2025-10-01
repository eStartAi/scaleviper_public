import os
import requests

token = os.getenv("TELEGRAM_BOT_TOKEN")
chat_id = os.getenv("TELEGRAM_USER_ID")
msg = os.getenv("TELEGRAM_MESSAGE", "📣 Alert from ScaleViper")

if token and chat_id:
    try:
        r = requests.post(f"https://api.telegram.org/bot{token}/sendMessage", data={
            "chat_id": chat_id,
            "text": msg
        })
        if r.status_code == 200:
            print("✅ Telegram notification sent.")
        else:
            print(f"⚠️ Telegram API error: {r.text}")
    except Exception as e:
        print(f"❌ Failed to send Telegram message: {e}")
