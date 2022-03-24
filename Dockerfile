FROM debian:buster

ENV DEBIAN_FRONTEND=noninteractive
ENV VERSION=2.4.15
ENV TARGETPLATFORM=amd64.deb
ENV URL=https://hndl.urbackup.org/Server/${VERSION}/debian/buster/urbackup-server_${VERSION}_${TARGETPLATFORM}

COPY entrypoint.sh /usr/bin/

RUN apt-get update \
&& apt-get install -y wget \
&& wget -q "$URL" -O /root/urbackup-server.deb \
&& echo "urbackup-server urbackup/backuppath string /backups" | debconf-set-selections \
&& apt-get install -y --no-install-recommends /root/urbackup-server.deb btrfs-tools \
&& rm /root/urbackup-server.deb \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# Backing up www-folder
RUN mkdir /web-backup && cp -R /usr/share/urbackup/* /web-backup
# Making entrypoint-script executable
RUN chmod +x /usr/bin/entrypoint.sh

EXPOSE 55414

# /usr/share/urbackup will not be exported to a volume by default, but it still can be bind mounted
VOLUME [ "/var/urbackup", "/var/log", "/backups" ]
ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["run"]