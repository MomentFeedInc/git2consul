FROM cimpress/git2consul
MAINTAINER Doug Clow @ MomentFeed

# Needed for ssh-keyscan
RUN apk update \
    && apk add openssh-client

# Install Consul
RUN set -x \
    && wget -O /tmp/consul_0.9.3_linux_amd64.zip https://releases.hashicorp.com/consul/0.9.3/consul_0.9.3_linux_amd64.zip \
    && unzip -d /usr/bin /tmp/consul_0.9.3_linux_amd64.zip \
    && rm /tmp/consul_0.9.3_linux_amd64.zip

RUN adduser -h /home/git2consul -D git2consul \
    && mkdir /home/git2consul/.ssh \
    && chown git2consul /home/git2consul/.ssh \
    && mkdir /var/lib/git2consul_cache \
    && chown git2consul /var/lib/git2consul_cache \
    && chown git2consul /etc/git2consul.d

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat

USER git2consul

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [   "/usr/bin/node", \
        "/usr/lib/node_modules/git2consul" \
    ]
