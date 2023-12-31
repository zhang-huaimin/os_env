#!/bin/bash
image_version=$1 # base:latest
self_proxy=$2 # 127.0.0.1:20171

image=`echo ${image_version} | awk -F ':' '{print $1}'`

git clone --depth=1 https://github.com/amix/vimrc.git ./configs/.vim_runtime

if [ -n "${self_proxy}" ]; then
    docker build . -f ${image}.Dockerfile -t ${image_version} --network host --build-arg "http_proxy=http://${self_proxy}" --build-arg "https_proxy=https://${self_proxy}"
else
    docker build . -f ${image}.Dockerfile -t ${image_version}
fi