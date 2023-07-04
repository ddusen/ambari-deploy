#!/bin/bash

#author: Sen Du
#email: dusen@gennlife.com
#created: 2023-06-30 10:00:00
#updated: 2023-06-30 10:00:00

set -e 
source 00_env

# 创建数据目录，赋权
function config_dir() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do 
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "mkdir -p ${DATA_ROOT:-/data}"
        ssh -n $ipaddr "chmod -R 777 ${DATA_ROOT:-/data}"
    done
}

# 配置一些插件 jars
function config_jar() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"

        ssh -n $ipaddr "mkdir -p /usr/share/java"
        scp -r libs/mysql-connector-java.jar  $ipaddr:/usr/share/java/
        
        ssh -n $ipaddr "mkdir -p /usr/share/hive"
        scp -r libs/commons-httpclient-3.1.jar  $ipaddr:/usr/share/hive/
        scp -r libs/elasticsearch-hadoop-6.3.0.jar  $ipaddr:/usr/share/hive/
        scp -r libs/jaxen-1.2.0.jar  $ipaddr:/usr/share/hive/
        scp -r libs/libfb303-0.9.3.jar  $ipaddr:/usr/share/hive/
    done
}

# 配置 dolphin
function config_dolphin() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        dolphin_home="/usr/hdp/$HDP_VERSION/dolphinscheduler"
        # dolphin 目录存在
        if ssh $ipaddr "test -e $dolphin_home"; then
            scp -r libs/mysql-connector-java.jar $ipaddr:$dolphin_home/alert-server/libs
            scp -r libs/mysql-connector-java.jar $ipaddr:$dolphin_home/api-server/libs
            scp -r libs/mysql-connector-java.jar $ipaddr:$dolphin_home/master-server/libs
            scp -r libs/mysql-connector-java.jar $ipaddr:$dolphin_home/standalone-server/libs
            scp -r libs/mysql-connector-java.jar $ipaddr:$dolphin_home/tools/libs
            scp -r libs/mysql-connector-java.jar $ipaddr:$dolphin_home/worker-server/libs

            ssh -n $ipaddr "chown -R dolphinscheduler:dolphinscheduler $dolphin_home"
        fi

    done
}

# 配置 iceberg
function config_iceberg() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        # 删除旧的
        ssh -n $ipaddr "rm -rf /usr/hdp/3.3.1.0-004/hive/lib/iceberg-hive-runtime-0.14.1.jar"
        ssh -n $ipaddr "rm -rf /usr/hdp/3.3.1.0-004/tez/iceberg-hive-runtime-0.14.1.jar"
        # 复制新的
        ssh -n $ipaddr "wget -O /usr/share/hive/iceberg-hive-runtime-1.3.0.jar $HTTPD_SERVER/others/iceberg-hive-runtime-1.3.0.jar" || true
    done
}

function main() {
    echo -e "$CSTART>10_hdp.sh$CEND"

    echo -e "$CSTART>>config_dir$CEND"
    config_dir

    echo -e "$CSTART>>config_jar$CEND"
    config_jar
    
    echo -e "$CSTART>>config_dolphin$CEND"
    # config_dolphin

    echo -e "$CSTART>>config_iceberg$CEND"
    config_iceberg

}

main
