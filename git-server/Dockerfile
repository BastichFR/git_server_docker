# Utilisation d'une image de base avec une version stable d'Alpine Linux
FROM alpine:latest

# Installation des dépendances nécessaires
RUN set -ex; \
    apk update; \
    apk add --no-cache \
    git \
    openssh \
    bash

# Generate SSH host keys
RUN ssh-keygen -A

# Delete Alpine welcome message
RUN rm /etc/motd

# Define variables for the git user
ENV GIT_USER=git \
    GIT_GROUP=git

ENV GIT_HOME=/home/${GIT_USER}
ENV SSH_AUTHORIZED_KEYS_FILE=${GIT_HOME}/.ssh/authorized_keys
ENV GIT_REPOSITORIES_PATH=${GIT_HOME}/repositories

# Create the git user and enable login by assigning a simple password
# Note that BusyBox implementation of `adduser` differs from Debian's
# and therefore options behave slightly differently
RUN set -eux; \
    addgroup "${GIT_GROUP}"; \
    adduser \
        --gecos "Git User" \
        --ingroup "${GIT_GROUP}" \
        --disabled-password \
        --home "${GIT_HOME}" \
        --shell "$(which git-shell)" \
        "${GIT_USER}"; \
    passwd -u git

# Create the necessary directory structure in the user's home directory
RUN set -eux; \
    mkdir -p ${GIT_HOME}/.ssh; \
    mkdir -p ${GIT_REPOSITORIES_PATH}; \
    touch ${SSH_AUTHORIZED_KEYS_FILE}; \
    chmod -R 700 ${GIT_HOME}/.ssh; \
    chmod -R 600 ${SSH_AUTHORIZED_KEYS_FILE}; \
    chmod -R u+xwr ${GIT_HOME}

# Copy git-shell-commands
COPY git-shell-commands ${GIT_HOME}/git-shell-commands
RUN set -eux; \
    cd ${GIT_HOME}/git-shell-commands; \
    cmds="ls mkdir rm vi clear"; \
    for cmd in $cmds; do \
        ln -s $(which $cmd) .; \
    done; \
    chmod -R +x ${GIT_HOME}/git-shell-commands; \
    chown -R ${GIT_USER}:${GIT_GROUP} ${GIT_HOME}

# Définition du répertoire de travail
WORKDIR ${GIT_HOME}

# Exposition du port SSH
EXPOSE 22

# Lancement du serveur SSH
COPY sshd_config /etc/ssh/sshd_config

CMD ["/usr/sbin/sshd", "-D"]
