#!/bin/bash

#author: Sen Du
#email: dusen@gennlife.com
#created: 2023-04-16 15:00:00
#updated: 2023-04-16 15:00:00

set -e 
source 00_env

# 从httpd私有软件库，下载 mysql8.0
function download_mysql() {
    echo -e "$CSTART>>>>$(hostname -I)$CEND"
    wget -O /tmp/mysql-8.0.30-require-rpms.tar.gz $HTTPD_SERVER/others/mysql-8.0.30-require-rpms.tar.gz
    wget -O /tmp/mysql-8.0.30-bundle-rpms.tar.gz $HTTPD_SERVER/others/mysql-8.0.30-bundle-rpms.tar.gz
}

# 安装 mysql8.0
function install_mysql() {
    echo -e "$CSTART>>>>$(hostname -I)$CEND"
    yum remove -y mariadb*

    tar -zxvf /tmp/mysql-8.0.30-require-rpms.tar.gz -C /tmp/
    yum localinstall -y /tmp/mysql-8.0.30-require-rpms/*.rpm || true # 忽略报错

    tar -zxvf /tmp/mysql-8.0.30-bundle-rpms.tar.gz -C /tmp/
    yum localinstall -y /tmp/mysql-8.0.30-bundle-rpms/*.rpm || true # 忽略报错
}

# 启动mysql
function start_mysql() {
    echo -e "$CSTART>>>>$(hostname -I)$CEND"
    systemctl start mysqld.service
    systemctl enable mysqld.service
}

# 配置 mysql8.0
function config_mysql() {
    echo -e "$CSTART>>>>$(hostname -I)$CEND"
    mysql_secure_installation

    # 手动执行，暂时未能实现自动执行
    # mysql_secure_installation <<EOF
    # y
    # 0
    # @GennLife2015
    # @GennLife2015
    # y
    # y
    # y
    # y
    # y
    # EOF
}

# 更新数据库，在 mysql 中创建用户，添加新用户和数据库
function update_database() {
    echo -e "$CSTART>>>>$(hostname -I)$CEND"
    mysql -hlocalhost -uroot -p"$MYSQL_ROOT_PASSWD" -e "SOURCE config/create_dbs.sql"
}

function main() {
    echo -e "$CSTART>07_mysql.sh$CEND"

    echo -e "$CSTART>>download_mysql$CEND"
    download_mysql

    echo -e "$CSTART>>install_mysql$CEND"
    install_mysql

    echo -e "$CSTART>>start_mysql$CEND"
    start_mysql

    echo -e "$CSTART>>config_mysql$CEND"
    config_mysql

    echo -e "$CSTART>>update_database$CEND"
    update_database
}

main
