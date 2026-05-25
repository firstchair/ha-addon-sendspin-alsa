ARG BUILD_FROM
FROM ${BUILD_FROM}

ENV LANG=C.UTF-8 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

RUN apk add --no-cache \
        ffmpeg \
        jq \
        portaudio \
        libsndfile \
        alsa-utils \
        pulseaudio-utils \
        alsa-plugins-pulse \
    && apk add --no-cache --virtual .build-deps \
        gcc \
        musl-dev \
        python3-dev \
        portaudio-dev \
        libsndfile-dev \
        linux-headers \
    && pip install --break-system-packages --no-cache-dir sendspin \
    && apk del .build-deps

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
