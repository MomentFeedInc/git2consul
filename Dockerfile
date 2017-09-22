# mfeed_config_docker

FROM cimpress/git2consul

RUN set -x \
    && wget -O /tmp/consul_0.9.3_linux_amd64.zip https://releases.hashicorp.com/consul/0.9.3/consul_0.9.3_linux_amd64.zip \
    && unzip -d /usr/bin /tmp/consul_0.9.3_linux_amd64.zip \
    && rm /tmp/consul_0.9.3_linux_amd64.zip

RUN adduser -h /home/git2consul -D git2consul \
    && mkdir /home/git2consul/.ssh \
    && chown git2consul /home/git2consul/.ssh \
    && mkdir /var/lib/git2consul_cache \
    && chown git2consul /var/lib/git2consul_cache

COPY git2consul.d/config.json /etc/git2consul.d/config.json

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat

ENV SSH_PRIVATE_KEY_PATH salt/mf/mfeed_config/ssh_private_key

USER git2consul

ENTRYPOINT [ "docker-entrypoint.sh" ]

CMD [   "--endpoint consul", \
        "--port 8500", \
        "--config-file /etc/git2consul.d/config.json" \
    ]
