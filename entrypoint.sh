#!/bin/bash

/usr/sbin/xrdp-sesman --nodaemon &
/usr/sbin/xrdp --nodaemon &

tmate -S /tmp/tmate.sock new-session -d               # Create a new tmate session detached
tmate -S /tmp/tmate.sock wait tmate-ready             # Blocks until the tmate is ready
TMATE_SSH=$(tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}')    # Fetch ssh connection details
TMATE_WEB=$(tmate -S /tmp/tmate.sock display -p '#{tmate_web}')    # Fetch web connection details

echo "tmate SSH connection details: $TMATE_SSH"
echo "tmate web connection details: $TMATE_WEB"

ngrok tcp 3389 &

# Give ngrok some time to initialize and create the tunnel
sleep 10

# Loop to fetch the ngrok connection details
while true; do
    ngrok_url=$(curl --silent http://localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')
    if [ "$ngrok_url" != "null" ]; then
        echo "ngrok connection details: $ngrok_url"
        echo "Instructions: Connect to the above ngrok tunnel using an RDP client. Use 'root' as the username and 'ilovedogshit' as the password."
        break
    else
        echo "Waiting for ngrok tunnel to be established..."
        sleep 5
    fi
done

# Keep the script running
tail -f /dev/null
