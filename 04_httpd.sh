#!/bin/bash

#author: Sen Du
#email: dusen.me@gmail.com
#created: 2023-04-16 10:00:00
#updated: 2023-04-16 10:00:00

set -e 
source 00_env

# 下载 cm、cdh 相关的软件
function download_files() {
    # wget -P /opt http://xxx/cloudera.6.3.1466458.tar.gz 
    # 把 cloudera.6.3.1466458.tar.gz 复制到中控机的 /opt 目录
    # scp ~/Downloads/$FILENAME root@$CCC:/opt/
    echo 'pass'
}

# 解压到指定目录
function unzip_files() {
    # echo -e "$CSTART>>>>$(hostname -I) [$(date +'%Y-%m-%d %H:%M:%S')]$CEND"
    # dist_dir="/var/www/html/cloudera"
    # mkdir -p $dist_dir && tar -zxvf /opt/$FILENAME -C $dist_dir
    echo 'pass'
}

# 安装 httpd：用作私有化 cm、cdh 的软件仓库
function install_httpd() {
    echo -e "$CSTART>>>>$(hostname -I) [$(date +'%Y-%m-%d %H:%M:%S')]$CEND"
    yum install -y httpd
}

# 启动 httpd
function start_httpd() {
    echo -e "$CSTART>>>>$(hostname -I) [$(date +'%Y-%m-%d %H:%M:%S')]$CEND"
    systemctl stop firewalld
    systemctl restart httpd
    systemctl enable httpd
    chkconfig httpd on
}

function main() {
    echo -e "$CSTART>04_httpd.sh$CEND"
    echo -e "$CSTART>>download_files$CEND"
    download_files

    echo -e "$CSTART>>unzip_files$CEND"
    unzip_files

    echo -e "$CSTART>>install_httpd$CEND"
    install_httpd

    echo -e "$CSTART>>start_httpd$CEND"
    start_httpd
}

main
