# Gswarm Role Setup Guide

## Overview
This guide provides instructions for configuring the Telegram monitoring bot for your Gensyn node and obtaining the Gswarm role.

---

## Step 1: Install Gswarm

### Install Go
```bash
# Remove existing Go installation
sudo rm -rf /usr/local/go

# Download and extract Go 1.22.4
curl -L https://go.dev/dl/go1.22.4.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local

# Configure PATH environment variables
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> $HOME/.bash_profile
source .bash_profile

# Verify installation
go version
```

### Install Gswarm
```bash
go install github.com/Deep-Commit/gswarm/cmd/gswarm@latest
```

### Verify Installation
```bash
gswarm --version
```

---

## Step 2: Configure Telegram Bot

### Create a Telegram Bot

1. Open Telegram and start a chat with @BotFather
2. Send the command `/newbot` and follow the prompts
3. Choose a name and username for your bot
4. Save the bot token provided by BotFather

### Retrieve Your Chat ID

1. Start a conversation with your newly created bot and send a test message
2. Open your web browser and navigate to:
   ```
   https://api.telegram.org/botYOUR_BOT_TOKEN/getUpdates
   ```
   
   **Important:** Replace `YOUR_BOT_TOKEN` with your actual bot token. Ensure the word `bot` remains in the URL before the token.

   **Example:** If your bot token is `1234567890:ABCdefGHIjklMNOpqrsTUVwxyz`, the URL should be:
   ```
   https://api.telegram.org/bot1234567890:ABCdefGHIjklMNOpqrsTUVwxyz/getUpdates
   ```

3. Enable pretty-print in your browser for improved readability

4. Locate your chat ID in the response

**Sample Response:**
```json
{
  "ok": true,
  "result": [
    {
      "message": {
        "message_id": 2001,
        "from": {
          "id": 123445789,
          "is_bot": false,
          "first_name": "GSwarm",
          "username": "gswarm0",
          "language_code": "en"
        },
        "chat": {
          "id": 123456789,
          "first_name": "GSwarm",
          "username": "gswarm0",
          "type": "private"
        },
        "date": 1704067200,
        "text": "Hello bot!"
      }
    }
  ]
}
```

**Extract the Chat ID:** Locate the `"chat":{"id":123456789}` field. In this example, the chat ID is `123456789`. This identifier will be used by the bot to send notifications.

**Note:** If the response shows an empty result `{"ok":true,"result":[]}`, send a message to your bot first, then refresh the URL.

---

## Step 3: Run Gswarm Bot

Execute the following command in your terminal:
```bash
gswarm
```

Follow the prompts to enter:
- Bot token
- Chat ID
- EOA address (available from the Gensyn Dashboard) link - https://dashboard.gensyn.ai/

---

## Step 4: Link Discord and Telegram Accounts

### Obtain Verification Code

1. Navigate to Discord and access the `#|swarm-link` channel
2. Enter the command `/link-telegram`
3. A verification code will be provided

### Complete Verification

1. Open your Telegram bot
2. Send the command `/verify <code>`, replacing `<code>` with the verification code received from Discord

Upon successful verification, your Discord and Telegram accounts will be linked, and you will receive The Swarm role.

---

## Support

For additional assistance, please refer to the official Gensyn documentation or contact the support team through the appropriate channels.
