FROM bestwu/deepin:panda
LABEL name=netease-cloud-music \
    version=1.1.0 \
    release=1 \
    maintainer='YJ <yj1516268@outlook.com>'

RUN apt-get update && \
    apt-get install -y --no-install-recommands locales && \
    echo 'zh_CN.UTF-8 UTF-8' > /etc/locale.gen && \
    locale-gen && \
    echo -e 'LANG="zh_CN.UTF-8"\nLANGUAGE="zh_CN:zh"\n' > /etc/default/locale && \
    source /etc/default/locale && \
    apt-get install -y --no-install-recommands fonts-wqy-microhei dbus-x11 netease-cloud-music && \
    apt-get autoremove -y --purge && apt-get autoclean -y && apt-get clean -y && \
    find /var/lib/apt/lists -type f -delete && find /var/cache -type f -delete && find /var/log -type f -delete && \
    find /usr/share/doc -type f -delete && find /usr/share/man -type f -delete && \

ENV LANGUAGE=zh_CN.UTF-8 \
    LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8 \
    TZ=UTF-8 \
    GID=1000 \
    UID=1000 \
    audio_gid=995 \
    app=netease-cloud-music

RUN groupadd -o -g $GID netease && \
    groupadd -o -g $audio_gid audio && \
    useradd -d "/home/netease" -m -o -u $UID -g netease -G audio netease

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
