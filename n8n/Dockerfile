ARG N8N_VERSION=2.2.6

FROM docker.n8n.io/n8nio/n8n:${N8N_VERSION} AS template

FROM alpine AS patcher

COPY --from=template /usr/local/lib/node_modules/n8n/dist/auth/auth.service.js /
COPY 00-auth.patch /

RUN apk add --no-cache patch && patch -p1 < 00-auth.patch

FROM docker.n8n.io/n8nio/n8n:${N8N_VERSION}

USER root

COPY --from=patcher /auth.service.js /usr/local/lib/node_modules/n8n/dist/auth/
COPY --chmod=755 hass-entrypoint.sh /

ENTRYPOINT ["tini", "--", "/hass-entrypoint.sh"]

LABEL \
    io.hass.version="${BUILD_VERSION}" \
    io.hass.type="addon" \
    io.hass.arch="${BUILD_ARCH}"
