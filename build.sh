#!/bin/bash
git clone --depth=1 https://github.com/amix/vimrc.git ./configs/.vim_runtime
docker build . -t os:latest