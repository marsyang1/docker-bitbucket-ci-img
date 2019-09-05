FROM marsyang1/bitbucket-pip-alpine:latest
FROM alpine:3.10

COPY --from=0 /usr/bin/node /usr/bin/
RUN apk add --no-cache binutils libstdc++ && \
  strip /usr/bin/node && \
  apk del binutils
