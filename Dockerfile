FROM alpine:latest

RUN apk add --update
RUN apk add --upgrade

# https://pkgs.alpinelinux.org/package/v3.17/community/x86_64/transmission
#RUN apk add transmission-daemon

# https://pkgs.alpinelinux.org/package/edge/community/x86_64/transmission

RUN apk add transmission-daemon --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community
RUN apk add wireguard-tools curl ncurses jq git
RUN rm -rf /var/cache/apk/*

RUN mkdir -p /root/.ssh \
    && chmod 0700 /root/.ssh

ARG ssh_pub_key

RUN echo "$ssh_pub_key" > /root/.ssh/authorized_keys
RUN apk add openrc openssh \
    && ssh-keygen -A

RUN sed -i "s/AllowTcpForwarding no/AllowTcpForwarding yes/" /etc/ssh/sshd_config
RUN sed -i "s/#PasswordAuthentication yes/PasswordAuthentication yes/" /etc/ssh/sshd_config
RUN sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/" /etc/ssh/sshd_config
RUN sed -i '/^#/d' /etc/ssh/sshd_config
RUN sed -i '/^$/d' /etc/ssh/sshd_config

RUN rc-status \
    # touch softlevel because system was initialized without openrc
    && touch /run/openrc/softlevel \
    && rc-service sshd start   
    
RUN mkdir -p /transmission/downloads \
  && mkdir -p /transmission/incomplete \
  && mkdir -p /transmission/watching \
  && mkdir -p /etc/transmission-daemon \
  && mkdir -p /transmission/downloads{ipt, mya, pub}

VOLUME ["/transmission/downloads"]
VOLUME ["/transmission/incomplete"]
VOLUME ["/transmission/watching"]
VOLUME ["/etc/transmission-daemon"]

COPY src/ .

RUN chmod +x /start-transmission.sh
EXPOSE 9091 22

ENV USERNAME=admin
ENV PASSWORD=password
ENV VPN_PROTOCOL=wineguard
ENV DISABLE_IPV6=yes
ENV DIP_TOKEN=no
ENV AUTOCONNECT=true
ENV PIA_PF=true
ENV PIA_DNS=true
ENV PIA_USER=username
ENV PIA_PASS=password

RUN sed -i "s:sysctl -q net.ipv4.conf.all.src_valid_mark=1:echo Skipping setting net.ipv4.conf.all.src_valid_mark:" /usr/bin/wg-quick

WORKDIR /manual-connections
RUN chmod +x run_setup.sh

CMD ["./run_setup.sh"]
