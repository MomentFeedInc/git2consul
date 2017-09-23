#!/usr/bin/env sh
set -x

# optionally get ssh key from consul
if [ -n $SSH_PRIVATE_KEY_PATH ]; then
    consul kv get $SSH_PRIVATE_KEY_PATH > ~/.ssh/id_rsa
    if [ $? != 0 ]; then 
        exit 1 
    fi
    chmod 600 ~/.ssh/id_rsa
fi

# optionally trust the git repo
if [ -n $GIT_SSH_HOST ]; then
    ssh-keyscan $GIT_SSH_HOST > ~/.ssh/known_hosts
fi

exec "$@"
