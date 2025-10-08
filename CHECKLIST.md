> Last reset: 2025-09-27 00:00:00 UTC by GitHub Actions

# 🛡️ Safe Go-Live Checklist (Practice Account)

Use this checklist before going live on the **OANDA Practice (Demo) Account**.  
This ensures your bot is safe, stable, and ready for simulated trading.

---

## ✅ Today's Backup Summary
- [x] Backup created: `backups/backup_20251008_063342`
- [x] `.env` synced safely and verified

---

## 1. 🔑 Security & Secrets
- [ ] `.env` file present (contains `OANDA_API_TOKEN`, `OANDA_ACCOUNT_ID`, `WEBHOOK_SECRET`)
- [ ] `.gitignore` includes `.env`, logs, DBs, venv, `__pycache__`
- [ ] Practice API keys used (`oanda_practice`, not live!)
- [ ] Secrets tested (no hardcoded values in code or GitHub repo)
- [ ] Tokens verified by running `python3 test_connection.py`

---

## 2. 📦 Code & Dependencies
- [ ] `requirements.txt` pinned (`Flask==...`, `requests==...`, etc.)
- [ ] `pip audit` run, no high vulnerabilities
- [ ] Unused deps removed
- [ ] Bot runs with **Python 3.12+**
- [ ] Code formatted (`black`, `flake8`)

---

## 3. ⚙️ Infrastructure & Deployment
- [ ] Bot runs under `systemd` service (auto-restart on crash/reboot)
- [ ] Healthcheck endpoint live (`/health`)
- [ ] Logs go to `webhook.log` and rotate daily
- [ ] Timezone set correctly for cron/systemd timers
- [ ] Daily `auto_close.py` tested & scheduled

---

## 4. 🔒 Network & Access
- [ ] Firewall only exposes required ports (`5001`, or Nginx reverse proxy → 443)
- [ ] SSH restricted to key-based login
- [ ] Fail2ban/IDS enabled (if server public)
- [ ] No admin/dashboard exposed without protection

---

## 5. 📊 Monitoring & Alerts
- [ ] Telegram alerts working (`test_telegram.py` ✅)
- [ ] Uptime monitoring enabled (e.g. UptimeRobot → `/health`)
- [ ] Trade logs recorded in `trade_logs.db`
- [ ] Backup strategy: `.db` → S3 or local snapshot
- [ ] Alerts trigger on API failure or rejected order

---

## 6. 🧪 Testing
- [ ] Webhook tested with `curl` (buy/sell order executed in Practice)
- [ ] Duplicate trade filter validated (1–5 min cool-down works)
- [ ] API failure retry logic tested
- [ ] Edge cases: invalid secret, bad symbol, market closed
- [ ] Unit tests run: `pytest`

---

## 7. 🧰 Data & Backups
- [x] `trade_logs.db` created & tested
- [x] Backups scheduled daily
- [x] Restore process tested (recover db < 5 min)
- [x] Log rotation confirmed (`logrotate` or systemd)

---

## 8. 🚀 Final Go/No-Go
- [ ] Confirm **Practice Account only** (no live keys)
- [ ] README.md updated with run instructions
- [ ] On-call/owner reachable
- [ ] Last dry run successful (`curl` or TradingView alert)
- [ ] All blockers cleared

---

✅ If all boxes are checked, you’re ready to go live on **Demo (Practice) Trading**!
