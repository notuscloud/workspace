FROM debian:9.6

ENV ARCH=amd64
ENV TERM=xterm-256color
ENV LANGUAGE=en_US.UTF-8

# Preparation
RUN apt update && apt install -y vim procps

# Install Hashicorp required packages
RUN apt install -y wget unzip

# Hashicorp tools
ENV CONSUL_VERSION=1.4.0
ENV VAULT_VERSION=1.0.1
ENV TERRAFORM_VERSION=0.11.11

ENV HASHICORP_RELEASES=https://releases.hashicorp.com

# Install Hashicorp consul
WORKDIR /var/tmp
RUN set -eux; \
    mkdir consul && \
    cd consul && \
    wget ${HASHICORP_RELEASES}/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_${ARCH}.zip && \
    unzip -d /bin consul_${CONSUL_VERSION}_linux_${ARCH}.zip && \
    cd .. && \
    rm -rf consul && \
    consul version

# Install Hashicorp vault
RUN set -eux; \
    mkdir vault && \
    cd vault && \
    wget ${HASHICORP_RELEASES}/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${ARCH}.zip && \
    unzip -d /bin vault_${VAULT_VERSION}_linux_${ARCH}.zip && \
    cd .. && \
    rm -rf vault && \
    vault version

# Install Hashicorp terraform
RUN set -eux; \
    mkdir terraform && \
    cd terraform && \
    wget ${HASHICORP_RELEASES}/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip && \
    unzip -d /bin terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip && \
    cd .. && \
    rm -rf terraform && \
    terraform version

# Install OhMyZsh
WORKDIR /root
RUN apt install -y curl zsh git
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# Install and preconfigure tmux
RUN apt install -y locales tmux
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN /usr/sbin/locale-gen
COPY dotfiles dotfiles
RUN ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf && \
    ln -s ~/dotfiles/tmux_shell_prompt ~/tmux_shell_prompt && \
    rm -f ~/.zshrc && ln -s ~/dotfiles/.zshrc ~/.zshrc && \
    ln -s ~/dotfiles/.shell_prompt.sh ~/.shell_prompt.sh

# Install ansible
RUN apt install -y ansible

# Entrypoint
COPY entrypoint.zsh /entrypoint.zsh
RUN chmod 755 /entrypoint.zsh
ENTRYPOINT /entrypoint.zsh
CMD /bin/zsh
