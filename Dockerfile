# Use Ubuntu as base image
FROM ubuntu:latest

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Update system and install necessary packages
RUN apt-get update && \
    apt-get install -y apt-utils wget curl xrdp tasksel kubuntu-desktop jq xterm

# Setup root password
RUN echo -e "root:zyyaf" | chpasswd

# Update xsession
RUN echo "startkde" > ~/.xsession

# Modify startwm.sh
RUN sed -i.bak '/fi/a #xrdp multiple users configuration \n startkde \n' /etc/xrdp/startwm.sh

# Start xrdp service
RUN service xrdp start

# Download and extract ngrok
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz && \
    tar -xvzf ngrok-v3-stable-linux-amd64.tgz && \
    rm ngrok-v3-stable-linux-amd64.tgz

# Setup ngrok
RUN ./ngrok authtoken 2bSC6McOE0ry6wWdTMGeQKZH68y_4VSp6XDV5y3hdy7659j5T && \
    ./ngrok tcp 3389

# Display ngrok connection details
RUN ngrok_url=$(curl --silent http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[0].public_url') && \
    if [ "$ngrok_url" != "null" ]; then \
        echo "ngrok connection details: $ngrok_url"; \
        echo "Instructions: Connect to the above ngrok tunnel using an RDP client. Use 'root' as the username and 'ilovedogshit' as the password."; \
    fi

#
