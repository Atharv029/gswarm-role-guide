#!/usr/bin/env bash


COLOR_CYAN='\033[0;36m'
COLOR_GREEN='\033[1;32m'
COLOR_RED='\033[1;31m'
COLOR_BLUE='\033[1;34m'
COLOR_MAGENTA='\033[1;35m'
COLOR_YELLOW='\033[1;33m'
COLOR_RESET='\033[0m'
NO_COLOR='\033[0m'
TEXT_BOLD='\033[1m'


echo -e "${COLOR_MAGENTA}${TEXT_BOLD}"
echo -e "${COLOR_CYAN}
  
  ___        _____ _                            
 / _ \      / ____| |                           
| | | |_  _| (___ | |__  _   _ _ __ ___  _ __   
| | | |\/ /\___ \ | '_ \| | | | '__/ _ \| '_ \  
| |_| |>  < ____) | | | | |_| | | | (_) | | | | 
 \___//_/\_\_____/|_| |_|\__, |_|  \___/|_| |_| 
                          __/ |                  
                         |___/                   
                                 
${COLOR_RED}                       
${NO_COLOR}"


GOLANG_INSTALL_PATH="/usr/local"
TG_CONFIG_FILE="telegram-config.json"
BACKEND_API="https://gswarm.dev/api"

set -e

echo "GSwarm Automated Setup Script"


if ! command -v jq >/dev/null 2>&1; then
  echo "jq not found. Installing..."
  sudo apt update -y
  sudo apt install -y jq
else
  echo "jq is present on the system"
fi


echo "Checking for latest Go release..."
LATEST_GO=$(curl -s https://go.dev/VERSION?m=text | head -n 1 | sed 's/go//')
GO_ARCHIVE="go${LATEST_GO}.linux-amd64.tar.gz"
GO_DOWNLOAD_URL="https://golang.org/dl/${GO_ARCHIVE}"
echo "Latest available Go version: $LATEST_GO"


setup_golang() {
  echo "Setting up Go $LATEST_GO..."
  curl -LO "$GO_DOWNLOAD_URL"
  sudo rm -rf ${GOLANG_INSTALL_PATH}/go
  sudo tar -C ${GOLANG_INSTALL_PATH} -xzf "$GO_ARCHIVE"
  rm "$GO_ARCHIVE"
  export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
  echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> "$HOME/.bashrc"
  echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> "$HOME/.profile"
  echo "Go successfully installed: $(/usr/local/go/bin/go version)"
}


is_version_older() {
  [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" != "$2" ]
}


if command -v go >/dev/null 2>&1; then
  CURRENT_GO=$(go version | awk '{print $3}' | sed 's/go//')
  echo "Found Go installation: $CURRENT_GO"
  if is_version_older "$CURRENT_GO" "$LATEST_GO"; then
    echo "Upgrading from $CURRENT_GO to $LATEST_GO..."
    sudo rm -rf "$GOLANG_INSTALL_PATH/go"
    if [ -d "$HOME/go" ]; then
      chmod -R u+w "$HOME/go"
      rm -rf "$HOME/go"
    fi
    setup_golang
  else
    echo "Current Go version meets requirements."
  fi
else
  setup_golang
fi


export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin


echo "Installing GSwarm command-line interface..."
go install github.com/Deep-Commit/gswarm/cmd/gswarm@latest
echo "GSwarm binary location: $(which gswarm)"


echo
echo "Please obtain your Telegram bot token from BotFather"
echo
read -p "Enter your bot token: " TELEGRAM_BOT_TOKEN


echo
echo "Send a test message to your bot on Telegram now."
read -p "After sending the message, press Enter to continue..."
echo "Retrieving your Telegram chat ID..."
USER_CHAT_ID=$(curl -s "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/getUpdates" | jq -r '.result[-1].message.chat.id')


if [[ -z "$USER_CHAT_ID" || "$USER_CHAT_ID" == "null" ]]; then
  echo "Unable to fetch chat ID. Please ensure you've sent a message to the bot."
  exit 1
fi


mkdir -p "$(dirname "$TG_CONFIG_FILE")"
cat > "$TG_CONFIG_FILE" <<EOF
{
  "bot_token": "$TELEGRAM_BOT_TOKEN",
  "chat_id": "$USER_CHAT_ID",
  "welcome_sent": true,
  "api_url": "$BACKEND_API"
}
EOF

echo "Configuration file created at $TG_CONFIG_FILE"

# Launch GSwarm
echo
echo "Launching GSwarm..."
gswarm
