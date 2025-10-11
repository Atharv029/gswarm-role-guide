# GSWARM ROLE GUIDE

All-in-one script that installs the GSwarm CLI tool, starts monitoring Gensyn Swarm rewards automatically, and sets up a Telegram bot for notifications.

## Quick Start

Run the following command:

````

bash <(curl -sL https://raw.githubusercontent.com/CodeDialect/gswarm-role/main/gswarm.sh)

````

## Setup Instructions

### 1. Telegram Bot Configuration

Follow the Telegram bot setup prompts:

- Create a new bot using @BotFather
- Paste your bot token when prompted
- Disable privacy mode by sending /setprivacy command to @BotFather
- Send a message to your bot so the script can fetch your chat ID

### 2. EOA Address

Get your EOA address from the Gensyn dashboard.

### 3. Configuration File

After setup, a telegram-config.json file will be created with the following structure:

```
{
  "bot_token": "123456:A***...",
  "chat_id": "*****",
  "welcome_sent": true,
  "api_url": "https://gswarm.dev/api"
}
```

### 4. Discord Verification

Complete the verification process:

- Navigate to the Gensyn Discord server
- Go to the swarm-link channel
- Execute the /link-telegram command
- Copy the verification code provided
- Return to your Telegram bot
- Send the verification command: /verify verificationCode
- Replace verificationCode with the code copied from Discord

Setup complete.
