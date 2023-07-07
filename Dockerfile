FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y xrdp jq curl wget tasksel xterm tmate && \
    tasksel install kubuntu-desktop && \
    echo "startkde" > ~/.xsession && \
    echo -e "root:ilovedogshit" | chpasswd

RUN wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip && \
    unzip ngrok-stable-linux-amd64.zip && \
    chmod +x ./ngrok && \
    mv ngrok /usr/local/bin

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
