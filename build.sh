#!/bin/bash

#author: Sen Du
#email: dusen.me@gmail.com
#created: 2023-06-16 21:00:00
#updated: 2023-06-16 21:00:00

set -e 
source 00_env

# 自动压缩文件
function zipfile() {
    cd ../
    tar -zcvf ambari.tar.gz ambari
    cd ambari/
}

function main() {
    echo -e "$CSTART build.sh$CEND"


    echo -e "$CSTART> zipfile$CEND"
    zipfile
}

main
