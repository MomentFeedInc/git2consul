#!/usr/bin/env bash
set -e

if [[ -n $BRANCH ]]; then
    sed -i "s/master/$BRANCH/" /etc/git2consul.d/config.json
fi

if [[ -n $SSH_PRIVATE_KEY ]]; then
    echo "$SSH_PRIVATE_KEY" > /home/git2consul/.ssh/id_rsa
    chown git2consul /home/git2consul/.ssh/id_rsa
    chmod 600 /home/git2consul/.ssh/id_rsa
fi

exec "/usr/bin/node /usr/lib/node_modules/git2consul"
