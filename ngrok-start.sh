#!/bin/bash

# Prerequisites:
# Setup the following environment variables
# 1. FC_ACCOUNT_ID
# 2. FC_ACCOUNT_TOKEN
# 3. YOUR_APP_PUBLIC_URL --> must be formatted 'http://username:password@subdomain.ngrok.io"
# 4. YOUR_APP_APPLICATION_ID
# 5. $NGROK_USERNAME
# 6. $NGROK_PASSWORD
# 7. $NGROK_PORT

# Execution
# REMEMBER! Execued this script in the currnt shell and not the subshell
# i.e.
# . ./ngrok-start.sh


# open new terminal & start ngrok
osascript <<END
tell application "Terminal"
	do script "ngrok http --auth $NGROK_USERNAME:$NGROK_PASSWORD $NGROK_PORT"
end tell
END

# wait for ngrok to start before curl
sleep 5

# get current subdomain url
NGROK_URL=$(curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"https:..([^"]*).*/\1/p'
);


# Reconstruct the public url string with the new subdoamin
new_public_url="http://$NGROK_USERNAME:$NGROK_PASSWORD@$NGROK_URL"
echo "New public url will be updated to: $new_public_url"$'\n'

echo "Beginning Updates..."

# Set th enew public url for your shell
# This is the line the script to be executed in the current shell . ./ngrok-start.sh
export ROCKWORM_PUBLIC_URL=$new_public_url

echo "Completed updating ROCKWORM_PUBLIC_URL to:"
echo $ROCKWORM_PUBLIC_URL
echo $'\n'

echo $"Update FreeClimb Application urls"$'\n'
# Update freeclimb via curl with the new subdomain
curl -s -X POST -d "{\"voiceUrl\":\"$new_public_url/calls\", \"callConnectUrl\":\"$new_public_url/calls\", \"smsUrl\":\"$new_public_url/messages\"}" -u $FC_ACCOUNT_ID:$FC_ACCOUNT_TOKEN https://freeclimb.com/apiserver/Accounts/$FC_ACCOUNT_ID/Applications/$ROCKWORM_APPLICATION_ID
echo $'\n'"Completed updating FreeClimb Applications Application Urls"

echo $'\n\n'"Script completed"
