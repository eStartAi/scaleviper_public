#!/bin/bash

# ========= Colors =========
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

cd ~/scaleviper || { echo -e "${RED}❌ Cannot enter scaleviper directory${NC}"; exit 1; }

echo -e "${BLUE}🔄 Git Safe Sync started...${NC}"

# Step 1. Stage all changes
git add .

# Step 2. Commit changes with timestamp
COMMIT_MSG="🔄 Auto-sync $(date '+%Y-%m-%d %H:%M:%S')"
git commit -m "$COMMIT_MSG" --allow-empty

# Step 3. Rebase with remote origin
echo -e "${YELLOW}📥 Pulling latest changes from origin/main...${NC}"
if ! git pull origin main --rebase; then
    echo -e "${RED}❌ Rebase failed. Manual resolution required.${NC}"
    TELEGRAM_MESSAGE="⚠️ Git Safe Sync FAILED (rebase conflict) on $(hostname)" python3 notify.py 2>> logs/telegram_errors.log
    exit 1
fi

# Step 4. Push to private repo
echo -e "${BLUE}📤 Pushing to private repo (origin)...${NC}"
if git push origin main; then
    echo -e "${GREEN}✅ Pushed to private repo${NC}"
else
    echo -e "${RED}❌ Failed to push to private repo${NC}"
    TELEGRAM_MESSAGE="⚠️ Git Safe Sync FAILED (origin push) on $(hostname)" python3 notify.py 2>> logs/telegram_errors.log
    exit 2
fi

# Step 5. Force push to public repo (mirror)
if git remote get-url public > /dev/null 2>&1; then
    echo -e "${BLUE}🌍 Force pushing to public repo (mirror)...${NC}"
    if git push public main --force; then
        echo -e "${GREEN}✅ Public repo mirror updated${NC}"
    else
        echo -e "${RED}❌ Failed to push to public repo${NC}"
        TELEGRAM_MESSAGE="⚠️ Git Safe Sync FAILED (public push) on $(hostname)" python3 notify.py 2>> logs/telegram_errors.log
        exit 3
    fi
fi

# Step 6. Success notification
TELEGRAM_MESSAGE="✅ Git Safe Sync SUCCESS on $(hostname)" python3 notify.py 2>> logs/telegram_errors.log
echo -e "${GREEN}🎉 Git Safe Sync completed successfully${NC}"
