#!/bin/bash

#author: Sen Du
#email: dusen@gennlife.com
#created: 2023-06-20 14:00:00
#updated: 2023-06-20 14:00:00

set -e 
source 00_env

# 配置一些插件 jars
function base_jars() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"

        ssh -n $ipaddr "mkdir -p /usr/share/java"
        scp -r libs/mysql-connector-java.jar  $ipaddr:/usr/share/java/
        
        ssh -n $ipaddr "mkdir -p /usr/share/hive"
        scp -r libs/commons-httpclient-3.1.jar  $ipaddr:/usr/share/hive/
        scp -r libs/elasticsearch-hadoop-6.3.0.jar  $ipaddr:/usr/share/hive/
        scp -r libs/jaxen-1.2.0.jar  $ipaddr:/usr/share/hive/
    done
}

function dolphin_jars() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        dolphin_home="/usr/hdp/$HDP_VERSION/dolphinscheduler"
        # dolphin 不存在则跳过
        if ssh $ipaddr "test -e $dolphin_home"; then
            continue
        fi

        scp -r libs/mysql-connector-java.jar $ipaddr:$dolphin_home/alert-server/libs
        scp -r libs/mysql-connector-java.jar $ipaddr:$dolphin_home/api-server/libs
        scp -r libs/mysql-connector-java.jar $ipaddr:$dolphin_home/master-server/libs
        scp -r libs/mysql-connector-java.jar $ipaddr:$dolphin_home/standalone-server/libs
        scp -r libs/mysql-connector-java.jar $ipaddr:$dolphin_home/tools/libs
        scp -r libs/mysql-connector-java.jar $ipaddr:$dolphin_home/worker-server/libs

        ssh -n $ipaddr "chown -R dolphinscheduler:dolphinscheduler $dolphin_home"
    done
}

function iceberg_jars() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"

        ssh -n $ipaddr "mkdir -p /usr/share/hive/auxlib"
        ssh -n $ipaddr "wget -O /usr/share/hive/auxlib/iceberg-hive-runtime-1.3.0.jar $HTTPD_SERVER/others/iceberg-hive-runtime-1.3.0.jar"
        ssh -n $ipaddr "wget -O /usr/share/hive/auxlib/libfb303-0.9.3.jar $HTTPD_SERVER/others/libfb303-0.9.3.jar"
    done
}

function main() {
    echo -e "$CSTART>06_jars.sh$CEND"

    echo -e "$CSTART>>base_jars$CEND"
    base_jars

    echo -e "$CSTART>>dolphin_jars$CEND"
    dolphin_jars

    echo -e "$CSTART>>iceberg_jars$CEND"
    iceberg_jars
}

main
