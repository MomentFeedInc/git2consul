FROM alpine:3.6
MAINTAINER Doug Clow @ MomentFeed

# Install deps
RUN apk --update add \
    nodejs nodejs-current-npm git openssh ca-certificates \
    openssh-client tini \
    && rm -rf /var/cache/apk/*

# Install git2consul
RUN npm install git2consul@0.12.13 --global \
    && mkdir -p /etc/git2consul.d

# Install Consul
ADD https://releases.hashicorp.com/consul/1.0.7/consul_1.0.7_linux_amd64.zip /tmp/
RUN unzip -d /usr/bin /tmp/consul_1.0.7_linux_amd64.zip && \
    rm /tmp/consul_1.0.7_linux_amd64.zip

RUN adduser -h /home/git2consul -D git2consul \
    && mkdir /home/git2consul/.ssh \
    && chown git2consul /home/git2consul/.ssh \
    && mkdir /var/lib/git2consul_cache \
    && chown git2consul /var/lib/git2consul_cache \
    && chown git2consul /etc/git2consul.d

COPY docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh

USER git2consul

ENTRYPOINT [ "/sbin/tini", "--", "/docker-entrypoint.sh" ]

CMD [   "/usr/bin/node", \
        "/usr/lib/node_modules/git2consul" \
    ]
