FROM python:3.10.5-alpine

ENV DEBUG="True" \
  DATA_FOLDER="/config" \
  VERSION="0.0.0" \
  BRANCH="edge" \
  BUILD_DATE="1/1/1970" \
  APP_DIR="/app" \
  CONFIG_DIR="/config" \
  PUID="1000" \
  PGID="1000" \
  UMASK="002" \
  TZ="Etc/UTC"

LABEL maintainer="freender" \
  org.opencontainers.image.created=$BUILD_DATE \
  org.opencontainers.image.url="https://github.com/freender/Varken" \
  org.opencontainers.image.source="https://github.com/freender/Varken" \
  org.opencontainers.image.version=$VERSION \
  org.opencontainers.image.revision=$VCS_REF \
  org.opencontainers.image.vendor="freender" \
  org.opencontainers.image.title="varken" \
  org.opencontainers.image.description="Varken is a standalone application to aggregate data from the Plex ecosystem into InfluxDB using Grafana for a frontend" \
  org.opencontainers.image.licenses="MIT"


RUN mkdir "${APP_DIR}" && \
  mkdir "${CONFIG_DIR}" && \
  adduser -u 99 -G 100 varken -D -h "${CONFIG_DIR}"

COPY . ${APP_DIR}

WORKDIR ${APP_DIR}

RUN \
  apk add --no-cache tzdata \
  && pip install --no-cache-dir -r ${APP_DIR}/requirements.txt \
  && sed -i "s/0.0.0/${VERSION}/;s/develop/${BRANCH}/;s/1\/1\/1970/${BUILD_DATE//\//\\/}/" varken/__init__.py

CMD cp ${APP_DIR}/data/varken.example.ini ${CONFIG_DIR}/varken.example.ini && python3 ${APP_DIR}/Varken.py
