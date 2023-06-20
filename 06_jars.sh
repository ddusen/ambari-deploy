#!/bin/bash

#author: Sen Du
#email: dusen@gennlife.com
#created: 2023-06-20 14:00:00
#updated: 2023-06-20 14:00:00

set -e 
source 00_env

# 配置一些插件 jars
function config_jars() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"

        scp -r libs/mysql-connector-java.jar $ipaddr:/usr/hdp/$HDP_VERSION/dolphinscheduler/alert-server/libs
        scp -r libs/mysql-connector-java.jar $ipaddr:/usr/hdp/$HDP_VERSION/dolphinscheduler/api-server/libs
        scp -r libs/mysql-connector-java.jar $ipaddr:/usr/hdp/$HDP_VERSION/dolphinscheduler/master-server/libs
        scp -r libs/mysql-connector-java.jar $ipaddr:/usr/hdp/$HDP_VERSION/dolphinscheduler/standalone-server/libs
        scp -r libs/mysql-connector-java.jar $ipaddr:/usr/hdp/$HDP_VERSION/dolphinscheduler/tools/libs
        scp -r libs/mysql-connector-java.jar $ipaddr:/usr/hdp/$HDP_VERSION/dolphinscheduler/worker-server/libs

        ssh -n $ipaddr "chown -R dolphinscheduler:dolphinscheduler /usr/hdp/$HDP_VERSION/dolphinscheduler"

        ssh -n $ipaddr "mkdir -p /usr/share/java"
        scp -r libs/mysql-connector-java.jar  $ipaddr:/usr/share/java/
        
        ssh -n $ipaddr "mkdir -p /usr/share/hive"
        scp -r libs/commons-httpclient-3.1.jar  $ipaddr:/usr/share/hive/
        scp -r libs/elasticsearch-hadoop-6.3.0.jar  $ipaddr:/usr/share/hive/
        scp -r libs/jaxen-1.2.0.jar  $ipaddr:/usr/share/hive/
    done
}

function main() {
    echo -e "$CSTART>06_jars.sh$CEND"

    echo -e "$CSTART>>config_jars$CEND"
    config_jars
}

main
