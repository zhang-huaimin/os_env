FROM base:latest AS os

# nvim
RUN export https_proxy=https://127.0.0.1:20171 && export http_proxy=http://127.0.0.1:20171 && git config --global http.proxy 127.0.0.1:20171 && git config --global https.proxy 127.0.0.1:20171 && \
    wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz && \
    git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim && \
    tar -xf nvim-linux64.tar.gz -C /bin/ && rm -rf nvim-linux64.tar.gz && \
    ln -s /bin/nvim-linux64/bin/nvim /bin/nvim && chmod 755 /bin/nvim && \
    nvim --headless "+Lazy! sync" +qa && \
    nvim --headless -c "MasonInstall clangd" -c "qall" && \
    nvim --headless -c "MasonInstall cmake-language-server" -c "qall" && \
    unset https_proxy && unset http_proxy && \
    nvim --headless -c "MasonInstall gopls" -c "qall" && \
    nvim --headless -c "MasonInstall pyright" -c "qall"
