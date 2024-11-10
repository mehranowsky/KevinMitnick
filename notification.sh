#!/bin/bash

# Set your API token and channel ID
API_TOKEN="7419580015:AAFDDDkY62aR9K4ueRlEC1ND_5O4bA8xUGM"
CHANNEL_ID="-1002443967270"

# Set the message text
MESSAGE="$1"

# Use curl to send the message
torsocks curl -s -X POST https://api.telegram.org/bot$API_TOKEN/sendMessage\
 -d chat_id=$CHANNEL_ID -d text="$MESSAGE"