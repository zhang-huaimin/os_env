FROM ubuntu:latest AS base

ENV DEBIAN_FRONTEND="noninteractive"

WORKDIR /root
COPY ./configs /root/

RUN mv sources.list /etc/apt/sources.list && cat ._bashrc >> ~/.bashrc && rm -rf ._bashrc && \
    apt-get update && apt-get install -y git locales tree \
    vim curl wget file texinfo cpio chrpath unzip npm lrzsz openssh-client libssl-dev pkg-config gcc-multilib \
    gcc make cmake clangd clang-format bear g++ autoconf flex jq bison ruby bc rsync zstd \
    python3 python3.10-venv python3-pip && \
    localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    ~/.vim_runtime/install_awesome_vimrc.sh && \
    apt clean && apt autoclean

RUN wget https://mirrors.aliyun.com/golang/go1.21.3.linux-386.tar.gz && \
    rm -rf /usr/local/go && tar -C /usr/local -xzf go1.21.3.linux-386.tar.gz && \
    rm -rf go1.21.3.linux-386.tar.gz && \
    ln -s /usr/local/go/bin/go /usr/bin/go && \
    go env -w GOPROXY=https://proxy.golang.com.cn

# rust
RUN wget https://rsproxy.cn/rustup-init.sh && \
    chmod +x rustup-init.sh && \
    ./rustup-init.sh -y && \
    mkdir -p ~/.cargo && . "$HOME/.cargo/env" && \
    cargo install mcfly && echo 'eval "$(mcfly init bash)"' >> ~/.bashrc && \
    cargo install gitui cross bottom && \
    cargo install ripgrep && cargo install fd-find && \
    cargo install zoxide && echo 'eval "$(zoxide init bash)"' >> ~/.bashrc && echo 'alias cd=z' >> ~/.bashrc
