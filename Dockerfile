# Use Ubuntu as base image
FROM ubuntu:20.04

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Update system and install necessary packages
RUN apt-get update && \
    apt-get install -y apt-utils wget curl xrdp tasksel kubuntu-desktop jq xterm
RUN echo root:zyyaf|chpasswd
RUN echo "startkde" > ~/.xsession
RUN sed -i.bak '/fi/a #xrdp multiple users configuration \n startkde \n' /etc/xrdp/startwm.sh
RUN service xrdp start
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.tgz && \
    tar -xvzf ngrok-v3-stable-linux-amd64.tgz && \
    rm ngrok-v3-stable-linux-amd64.tgz
RUN ./ngrok authtoken 2bSC6McOE0ry6wWdTMGeQKZH68y_4VSp6XDV5y3hdy7659j5T
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
EXPOSE 3389
ENTRYPOINT ["/entrypoint.sh"]
