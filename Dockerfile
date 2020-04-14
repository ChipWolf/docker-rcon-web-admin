FROM node:10

ARG RCON_WEB_ADMIN_VERSION=master

ADD https://github.com/ChipWolf/rcon-web-admin/archive/master.tar.gz /tmp/rcon-web-admin.tgz

RUN tar -C /opt -xf /tmp/rcon-web-admin.tgz && \
    rm /tmp/rcon-web-admin.tgz && \
    ln -s /opt/rcon-web-admin-${RCON_WEB_ADMIN_VERSION} /opt/rcon-web-admin

WORKDIR /opt/rcon-web-admin

RUN npm install \
  && node src/main.js install-core-widgets \
  && chown -R node:node /opt/rcon-web-admin-${RCON_WEB_ADMIN_VERSION} \
  && chmod -R 0755 startscripts *

# 4326: web UI
# 4327: websocket
EXPOSE 4326 4327

VOLUME ["/opt/rcon-web-admin/db"]

ENV UID=1000 GID=1000 \
  RWA_ENV=TRUE

ENTRYPOINT ["/usr/local/bin/node", "src/main.js", "start"]
