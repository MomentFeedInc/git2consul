#!/usr/bin/env sh
set -x

# optionally get ssh key from consul
consul kv get $SSH_PRIVATE_KEY_PATH
if [ $? == 0 ]; then
    consul kv get $SSH_PRIVATE_KEY_PATH > /home/git2consul/.ssh/id_rsa
    chmod 600 /home/git2consul/.ssh/id_rsa
fi

# optionally get config.json from consul
consul kv get $CONFIG_JSON_PATH
if [ $? == 0 ]; then
    consul kv get $CONFIG_JSON_PATH > /etc/git2consul.d/config.json
fi

exec /usr/bin/node /usr/lib/node_modules/git2consul --config-file /etc/git2consul.d/config.json
