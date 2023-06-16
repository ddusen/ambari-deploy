#!/bin/bash

#author: Sen Du
#email: dusen@gennlife.com
#created: 2023-06-16 15:00:00
#updated: 2023-06-16 15:00:00

set -e 
source 00_env

# 配置 ambari repos
function config_repos() {
    cp config/ambari.repo /etc/yum.repos.d/
    sed -i "s/TO_AMBARI_REPO_URL/$HTTPD_SERVER/ambari/$AMBARI_VERSION/" /etc/yum.repos.d/ambari.repo
    yum clean all
    yum makecache
    yum repolist
}

# 安装 ambari
function install_ambari() {
    echo -e "$CSTART>>>>$(hostname -I)$CEND"
    yum install -y ambari-server
}
ambari-server setup --jdbc-db=mysql --jdbc-driver=/usr/share/java/mysql-connector-j-8.0.33.jar
# 启动 ambari
function start_ambari() {
    echo -e "$CSTART>>>>$(hostname -I)$CEND"
    systemctl start ambari-server
    systemctl enable ambari-server
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
