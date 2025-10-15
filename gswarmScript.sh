#!/usr/bin/env bash

CYAN='\033[0;36m'
GREEN='\033[1;32m'
RED='\033[1;31m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
YELLOW='\033[1;33m'
RESET='\033[0m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${PURPLE}${BOLD}"
echo -e "${CYAN}
 
  ___        _____ _                           
 / _ \      / ____| |                          
| | | |_  _| (___ | |__  _   _ _ __ ___  _ __  
| | | |\/ /\___ \ | '_ \| | | | '__/ _ \| '_ \ 
| |_| |>  < ____) | | | | |_| | | | (_) | | | |
 \___//_/\_\_____/|_| |_|\__, |_|  \___/|_| |_|
                          __/ |                 
                         |___/                  
                                
                                                                                                                                
${RED}                      :: Powered by 0xShyron ::
${NC}"

GO_INSTALL_DIR="/usr/local"
CONFIG_PATH="telegram-config.json"
API_URL="https://gswarm.dev/api"

set -e

echo "GSwarm Full One-Click Installer"

if ! command -v jq >/dev/null 2>&1; then
  echo "Installing jq..."
  sudo apt update -y
  sudo apt install -y jq
else
  echo "jq is already installed"
fi

echo "Fetching latest Go version..."
GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n 1 | sed 's/go//')
GO_TARBALL="go${GO_VERSION}.linux-amd64.tar.gz"
GO_URL="https://golang.org/dl/${GO_TARBALL}"
echo "Latest Go version: $GO_VERSION"

install_go() {
  echo "Installing Go $GO_VERSION..."
  curl -LO "$GO_URL"
  sudo rm -rf ${GO_INSTALL_DIR}/go
  sudo tar -C ${GO_INSTALL_DIR} -xzf "$GO_TARBALL"
  rm "$GO_TARBALL"
  export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
  echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> "$HOME/.bashrc"
  echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> "$HOME/.profile"
  echo "Go installed: $(/usr/local/go/bin/go version)"
}

version_lt() {
  [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" != "$2" ]
}

if command -v go >/dev/null 2>&1; then
  INSTALLED_GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
  echo "Detected Go version: $INSTALLED_GO_VERSION"
  if version_lt "$INSTALLED_GO_VERSION" "$GO_VERSION"; then
    echo "Go version is less than $GO_VERSION. Replacing..."
    sudo rm -rf "$GO_INSTALL_DIR/go"
    if [ -d "$HOME/go" ]; then
      chmod -R u+w "$HOME/go"
      rm -rf "$HOME/go"
    fi
    install_go
  else
    echo "Go version is sufficient."
  fi
else
  install_go
fi

export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

echo "Installing GSwarm CLI..."
go install github.com/Deep-Commit/gswarm/cmd/gswarm@latest
echo "GSwarm installed at: $(which gswarm)"

echo
echo "Telegram Bot Setup:"
echo "1. Open Telegram and search @BotFather"
echo "2. Send /newbot and follow the steps"
echo "3. Copy the bot token (format: 123456:ABC-DEF...)"
echo
read -p "Paste your bot token here: " BOT_TOKEN
echo
echo "Now send any message to your bot in Telegram."
read -p "Press Enter after sending the message..."
echo "Fetching your chat ID..."
CHAT_ID=$(curl -s "https://api.telegram.org/bot${BOT_TOKEN}/getUpdates" | jq -r '.result[-1].message.chat.id')

if [[ -z "$CHAT_ID" || "$CHAT_ID" == "null" ]]; then
  echo "Failed to retrieve chat ID. Did you message the bot first?"
  exit 1
fi

mkdir -p "$(dirname "$CONFIG_PATH")"
cat > "$CONFIG_PATH" <<EOF
{
  "bot_token": "$BOT_TOKEN",
  "chat_id": "$CHAT_ID",
  "welcome_sent": true,
  "api_url": "$API_URL"
}
EOF

echo "Configuration saved to $CONFIG_PATH"

echo
echo "Starting GSwarm monitor..."
gswarm

