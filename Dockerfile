FROM alpine:3.18

ENV TRACCAR_VERSION 4.13

WORKDIR /opt/traccar

RUN set -ex && \
    apk add --no-cache --no-progress openjdk11-jre-headless wget unzip rsync tzdata && \
    ln -s /usr/share/zoneinfo/Europe/Brussels /etc/localtime && \
    wget -qO /tmp/traccar.zip https://github.com/traccar/traccar/releases/download/v$TRACCAR_VERSION/traccar-other-$TRACCAR_VERSION.zip && \
    unzip -qo /tmp/traccar.zip -d /opt/traccar && \
    rm /tmp/traccar.zip && \
    wget -qO /tmp/traccar.zip https://github.com/Jorge-Nunes/mod413/archive/refs/heads/main.zip && \
    unzip -qo /tmp/traccar.zip -d /tmp && \ 
    rsync -aq /tmp/mod413-main/ /opt/traccar && \
    rm /tmp/traccar.zip && \
    rm -rf /tmp/* && \
    apk del wget unzip rsync

ENTRYPOINT ["java", "-Xms1g", "-Xmx1g", "-Djava.net.preferIPv4Stack=true"]

CMD ["-jar", "tracker-server.jar", "conf/traccar.xml"]
