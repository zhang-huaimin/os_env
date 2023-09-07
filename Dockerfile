FROM ubuntu:latest AS os

ENV DEBIAN_FRONTEND="noninteractive"

RUN echo "deb http://mirrors.ustc.edu.cn/ubuntu/ jammy main restricted " > /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-updates main restricted " >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/ubuntu/ jammy universe " >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-updates universe " >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/ubuntu/ jammy multiverse " >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-updates multiverse " >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse " >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-security main restricted " >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-security universe " >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/ubuntu/ jammy-security multiverse " >> /etc/apt/sources.list && \
    echo "deb http://archive.canonical.com/ubuntu jammy partner " >> /etc/apt/sources.list && \
    apt-get update && apt-get install -y \
        curl wget openssh-client libssl-dev pkg-config\
        gcc make \
        vim \
        python3

# rust
RUN echo 'export RUSTUP_DIST_SERVER="https://rsproxy.cn"' >> ~/.bashrc && \
    echo 'export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"' >> ~/.bashrc && \
    echo 'source "$HOME/.cargo/env"' >> ~/.bashrc && \
    export RUSTUP_DIST_SERVER="https://rsproxy.cn" && \
    export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup" && \
    curl --proto '=https' --tlsv1.2 -sSf https://rsproxy.cn/rustup-init.sh > rustup-init.sh && \
    chmod +x rustup-init.sh && \
    ./rustup-init.sh -y && \
    mkdir -p ~/.cargo

COPY cargo_config .cargo/config

RUN . ~/.bashrc > /dev/null 2>&1; \
    cargo install \
    gitui