Gswarm Role Guide

Guide to setup the tg moinotring bot for our gensyn node and get the gswarm role


Step 1. Install Gswarm
````

# Install Go:
sudo rm -rf /usr/local/go
curl -L https://go.dev/dl/go1.22.4.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
echo 'export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin' >> $HOME/.bash_profile
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> $HOME/.bash_profile
source .bash_profile
go version

````
````
go install github.com/Deep-Commit/gswarm/cmd/gswarm@latest

````

Verify Installation
```` gswarm --version ````

Step 2. Setup Telegram Bot
1. Create a Telegram Bot:

Chat with @BotFather on Telegram
Send /newbot and follow the instructions (Choose a name & username)
Save the bot token provided

2. Get Your Chat ID:

Start a chat with your new bot and send some messages to it

Visit ``` https://api.telegram.org/botYOUR_BOT_TOKEN/getUpdates ``` in your browser
Replace <YOUR_BOT_TOKEN> with your actual bot token.

Ensure the word bot remains in the URL before the token.

Find your chat ID in the response

Example: If your bot token is 1234567890:ABCdefGHIjklMNOpqrsTUVwxyz, visit:
``` https://api.telegram.org/bot1234567890:ABCdefGHIjklMNOpqrsTUVwxyz/getUpdates ```

In your Browser, enable Pretty-print for better readability.
Sample Response:
````

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

````
Extract the Chat ID: Look for the "chat":{"id":123456789} field. In this example, the chat ID is 123456789. This is your Telegram ID that the bot will use to send you notifications.
Note: If you get an empty result {"ok":true,"result":[]}, you may need to send a message to your bot first, then refresh the URL.

Step 3. Run Gswarm Bot
Run  ``` gswarm ``` in your terminal now and follow the prompts to enter your bot token, chat ID, and EOA address

You'll find EOA address by logging in the Gensyn Dashboard


Step 4. Linking Discord and Telegram

To link your Discord and Telegram accounts:

1. Get the verification code:

Go to Discord in #|swarm-link channel
Type /link-telegram (this gives you a code)

2. Verify the code:

Go to your Telegram bot
Type /verify <code> (replace <code> with the code you received)
This will link your Discord and Telegram accounts and you earn The Swarm role.
