FROM ubuntu:latest AS os

ENV DEBIAN_FRONTEND="noninteractive"

COPY ./configs /root/

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
    apt-get update && apt-get install -y git vim \
    curl wget unzip npm lrzsz openssh-client libssl-dev pkg-config \
    gcc make cmake clangd \
    python3 python3.10-venv python3-pip && \
    pip config set global.index-url http://mirrors.aliyun.com/pypi/simple && pip3 config set install.trusted-host mirrors.aliyun.com && \
    echo 'alias r=realpath' >> ~/.bashrc && \
    ~/.vim_runtime/install_awesome_vimrc.sh

# rust
RUN echo 'export RUSTUP_DIST_SERVER="https://rsproxy.cn"' >> ~/.bashrc && \
    echo 'export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"' >> ~/.bashrc && \
    echo 'source "$HOME/.cargo/env"' >> ~/.bashrc && \
    export RUSTUP_DIST_SERVER="https://rsproxy.cn" && \
    export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup" && \
    wget https://rsproxy.cn/rustup-init.sh && \
    chmod +x rustup-init.sh && \
    ./rustup-init.sh -y && \
    mkdir -p ~/.cargo && . "$HOME/.cargo/env" && \
    cargo install mcfly && echo 'history -w' >> ~/.bashrc && echo 'eval "$(mcfly init bash)"' >> ~/.bashrc && \
    cargo install gitui cross && \
    cargo install ripgrep && cargo install fd-find && \
    cargo install zoxide && echo 'eval "$(zoxide init bash)"' >> ~/.bashrc && echo 'alias cd=z' >> ~/.bashrc

# nvim
# FROM rust:latest AS nvim
# RUN git config --global http.proxy 127.0.0.1:20171 && \
#     git config --global https.proxy 127.0.0.1:20171 && \
#     wget https://github.com/torvalds/linux/blob/master/.clang-format && \
#     wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz && \
#     tar -xf nvim-linux64.tar.gz -C /bin/ && rm -rf nvim-linux64.tar.gz && \
#     ln -s /bin/nvim-linux64/bin/nvim /bin/nvim && chmod 755 /bin/nvim && \
#     git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim