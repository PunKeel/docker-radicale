FROM python:3-alpine
MAINTAINER Thomas Queste <tom@tomsquest.com>

RUN apk add --update tini su-exec

RUN pip install radicale

# User with no home, no password
RUN adduser -s /bin/false -D -H radicale

COPY config /radicale
RUN mkdir -p /radicale/data && chown radicale /radicale/data
WORKDIR /radicale/data

VOLUME /radicale/data
EXPOSE 5232

# Tiny starts our entrypoint which starts Radicale
COPY docker-entrypoint.sh /usr/local/bin
ENTRYPOINT ["/sbin/tini", "--", "docker-entrypoint.sh"]
CMD ["radicale", "--config", "/radicale/config"]
