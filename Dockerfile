FROM debian:9.6 as hashicorp

ENV ARCH=amd64

# Install Hashicorp required packages
RUN apt update && apt install -y wget unzip

# Hashicorp tools
ENV CONSUL_VERSION=1.5.2
ENV VAULT_VERSION=1.1.3
ENV TERRAFORM_VERSION=0.12.4

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

# ----------
# MAIN STAGE
# ----------
FROM debian:9.6

ENV TERM=xterm-256color
ENV LANGUAGE=en_US.UTF-8

# Fetch Hashicorp binairies from the previous build stage
COPY --from=hashicorp /bin/terraform /bin/.
COPY --from=hashicorp /bin/consul /bin/.
COPY --from=hashicorp /bin/vault /bin/.

# Install and configure supervisor
RUN apt-get update && apt-get install -y supervisor
COPY config/supervisord.conf /etc/supervisord.conf
# Install wrappers
COPY wrappers /opt/wrappers
RUN chmod -Rv 755 /opt/wrappers

# Create tmux user
RUN useradd tmux -s /bin/zsh -b /home -m

# Preparation
RUN apt update && apt install -y vim procps gnupg gnupg2 gnupg1 curl zsh git wget unzip

# Install and preconfigure tmux
WORKDIR /data
RUN apt install -y locales tmux
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
RUN /usr/sbin/locale-gen
COPY dotfiles dotfiles
RUN ls -al /home/tmux && ln -s /data/dotfiles/.tmux.conf /home/tmux/.tmux.conf && \
    ln -s /data/dotfiles/tmux_shell_prompt /home/tmux/tmux_shell_prompt && \
    ln -s /data/dotfiles/.shell_prompt.sh /home/tmux/.shell_prompt.sh

# Install ansible
RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 && \
    apt-get update && apt-get -y install ansible && ansible --version

# Entrypoint
COPY entrypoint.zsh /entrypoint.zsh
RUN chmod 755 /entrypoint.zsh

WORKDIR /home/tmux
USER tmux
# Install OhMyZsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN rm -f /home/tmux/.zshrc && ln -s /data/dotfiles/.zshrc /home/tmux/.zshrc

ENTRYPOINT /entrypoint.zsh
CMD /bin/zsh

