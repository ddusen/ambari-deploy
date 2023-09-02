#!/bin/bash

#author: Sen Du
#email: dusen.me@gmail.com
#created: 2023-06-16 15:00:00
#updated: 2023-06-16 15:00:00

set -e 
source 00_env

# ambari server 依赖 postgres，需要移除旧版本，避免冲突
function remove_postgres() {
    echo -e "$CSTART>>>>$(hostname -I) [$(date +'%Y-%m-%d %H:%M:%S')]$CEND"
    yum remove -y postgres*
}

# 安装 ambari
function install_ambari() {
    echo -e "$CSTART>>>>$(hostname -I) [$(date +'%Y-%m-%d %H:%M:%S')]$CEND"
    yum install -y ambari-server
}

function config_jar() {
    echo -e "$CSTART>>>>$(hostname -I) [$(date +'%Y-%m-%d %H:%M:%S')]$CEND"
    mkdir -p /usr/share/java
    cp libs/mysql-connector-java.jar /usr/share/java/mysql-connector-java.jar
}

# 配置 ambari
function config_ambari() {
    echo -e "$CSTART>>>>$(hostname -I) [$(date +'%Y-%m-%d %H:%M:%S')]$CEND"
    ambari-server stop
    
    mkdir -p /etc/ambari-server/conf/
    cp config/ambari.properties /etc/ambari-server/conf/ambari.properties
    sed -i "s#TODO_MYSQL_HOST#$MYSQL_HOST#g" /etc/ambari-server/conf/ambari.properties
    echo "$MYSQL_AMBARI_PASSWD" > /etc/ambari-server/conf/password.dat
    
    ambari-server setup \
        --database=mysql \
        --databasehost=$MYSQL_HOST \
        --databaseport=3306 \
        --databasename=ambari \
        --databaseusername=ambari \
        --databasepassword=$MYSQL_AMBARI_PASSWD \
        --jdbc-db=mysql \
        --jdbc-driver=/usr/share/java/mysql-connector-java.jar
}

# 更新数据库
function update_database() {
    echo -e "$CSTART>>>>$(hostname -I) [$(date +'%Y-%m-%d %H:%M:%S')]$CEND"
    mysql -hlocalhost -uroot -p"$MYSQL_ROOT_PASSWD" -Dambari -e "SOURCE /var/lib/ambari-server/resources/Ambari-DDL-MySQL-CREATE.sql"
}

# 启动 ambari
function start_ambari() {
    echo -e "$CSTART>>>>$(hostname -I) [$(date +'%Y-%m-%d %H:%M:%S')]$CEND"
    ambari-server start
}

function main() {
    echo -e "$CSTART>09_ambari_server.sh$CEND"
    
    echo -e "$CSTART>>remove_postgres$CEND"
    remove_postgres

    echo -e "$CSTART>>install_ambari$CEND"
    install_ambari

    echo -e "$CSTART>>config_jar$CEND"
    config_jar

    echo -e "$CSTART>>config_ambari$CEND"
    config_ambari

    echo -e "$CSTART>>update_database$CEND"
    update_database

    echo -e "$CSTART>>start_ambari$CEND"
    start_ambari

}

main
