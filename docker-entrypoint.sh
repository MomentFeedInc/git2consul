#!/usr/bin/env sh
set -x

if [ -n "$BRANCH" ]; then
    sed -i "s/master/$BRANCH/" /etc/git2consul.d/config.json
fi

consul kv get $SSH_PRIVATE_KEY_PATH > /dev/null
if [ $? == 0 ]; then
    consul kv get $SSH_PRIVATE_KEY_PATH > /home/git2consul/.ssh/id_rsa
    chown git2consul /home/git2consul/.ssh/id_rsa
    chmod 600 /home/git2consul/.ssh/id_rsa
fi

exec /usr/bin/node /usr/lib/node_modules/git2consul
