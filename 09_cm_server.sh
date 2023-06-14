#!/bin/bash

#author: Sen Du
#email: dusen@gennlife.com
#created: 2023-04-16 16:00:00
#updated: 2023-04-16 16:00:00

set -e 
source 00_env

# 移除旧版本的 cm server
function remove_old_server() {
    echo -e "$CSTART>>>>$(hostname -I)$CEND"
    yum remove -y cloudera-manager* || true
}

# 安装 cloudera manager server
function install_server() {
    echo -e "$CSTART>>>>$(hostname -I)$CEND"
    rpm -ivh $HTTPD_SERVER/cm6/6.3.1/cloudera-manager-daemons-6.3.1-1466458.el7.x86_64.rpm || true
    rpm -ivh $HTTPD_SERVER/cm6/6.3.1/cloudera-manager-agent-6.3.1-1466458.el7.x86_64.rpm || true
    rpm -ivh $HTTPD_SERVER/cm6/6.3.1/cloudera-manager-server-6.3.1-1466458.el7.x86_64.rpm || true
}

# 配置 cloudera manager server
function config_server() {
    echo -e "$CSTART>>>>$(hostname -I)$CEND"
    mkdir -p /etc/cloudera-scm-server
    cp /etc/cloudera-scm-server/db.properties /etc/cloudera-scm-server/db.properties.bak || true
    cp config/cm_server /etc/cloudera-scm-server/db.properties
    sed -i "s/TODO_MYSQL_HOST/$MYSQL_HOST/g" /etc/cloudera-scm-server/db.properties
    chmod 644 /etc/cloudera-scm-server/db.properties
}

# 配置 本地存储库
function config_parcel_repo() {
    echo -e "$CSTART>>>>$(hostname -I)$CEND"
    parcel_dir="/opt/cloudera/parcel-repo"
    mkdir -p $parcel_dir
    wget -O $parcel_dir/CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel $HTTPD_SERVER/cdh6/6.3.2/parcels/CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel || true
    wget -O $parcel_dir/CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.sha $HTTPD_SERVER/cdh6/6.3.2/parcels/CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.sha
    wget -O $parcel_dir/CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.sha1 $HTTPD_SERVER/cdh6/6.3.2/parcels/CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.sha1
    wget -O $parcel_dir/CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.torrent $HTTPD_SERVER/cdh6/6.3.2/parcels/CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.torrent
    wget -O $parcel_dir/CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.torrent.sha $HTTPD_SERVER/cdh6/6.3.2/parcels/CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.torrent.sha
    wget -O $parcel_dir/CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.torrent.sha1 $HTTPD_SERVER/cdh6/6.3.2/parcels/CDH-6.3.2-1.cdh6.3.2.p0.1605554-el7.parcel.torrent.sha1
    wget -O $parcel_dir/manifest.json $HTTPD_SERVER/cdh6/6.3.2/parcels/manifest.json
    chown -R cloudera-scm:cloudera-scm $parcel_dir
    chmod -R ugo+rX $parcel_dir
}

# 重启 cloudera manager server
function restart_server() {
    echo -e "$CSTART>>>>$(hostname -I)$CEND"
    systemctl restart cloudera-scm-server; 
    systemctl enable cloudera-scm-server;
    chkconfig cloudera-scm-server on
}

function main() {
    echo -e "$CSTART>09_cm_server.sh$CEND"

    echo -e "$CSTART>>remove_old_server$CEND"
    remove_old_server

    echo -e "$CSTART>>install_server$CEND"
    install_server

    echo -e "$CSTART>>config_server$CEND"
    config_server

    echo -e "$CSTART>>config_parcel_repo$CEND"
    config_parcel_repo

    echo -e "$CSTART>>restart_server$CEND"
    restart_server
}

main
