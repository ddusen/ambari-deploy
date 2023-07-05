#!/bin/bash

#author: Sen Du
#email: dusen@gennlife.com
#created: 2023-04-18 15:00:00
#updated: 2023-04-18 15:00:00

set -e 
source 00_env

# 避免误操作，添加输入密码步骤
function identification() {
    read -s -p "请输入密码: " pswd
    shapswd=$(echo $pswd | sha1sum | head -c 10)
    if [[ "$shapswd" == "d5b3776603" ]]; then
        echo && true
    else
        echo && false
    fi
}

# 清理 java 服务
function clean_java() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "sed -i '/JAVA_HOME/d' /etc/profile"
        ssh -n $ipaddr "rm -rf /opt/jdk1.8.0_202"
        ssh -n $ipaddr "unlink /usr/java/default"
    done
}

# 清理 mysql 服务
function clean_mysql() {
    echo -e "$CSTART>>>>$(hostname -I)$CEND"
    systemctl stop mysql*
    yum remove -y mariadb*
    yum remove -y mysql*
    yum remove -y MySQL*
    rm -rf /var/lib/mysql*
    rm -rf /var/log/mysql*
    rm -rf /usr/lib64/mysql*
    rm -rf /usr/include/mysql*
    rm -rf /var/share/mysql*
    rm -rf /etc/my.cnf
    rm -rf /root/.mysql_secret
    rm -rf /root/.mysql_history
}

# 清理所有服务器上的 ambari 服务
function clean_ambari() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "systemctl stop ambari*"
        ssh -n $ipaddr "yum remove -y ambari*"
        ssh -n $ipaddr "rm -rf /opt/ambari*"
        ssh -n $ipaddr "rm -rf /etc/ambari*"
        ssh -n $ipaddr "rm -rf /var/lib/ambari*"
        ssh -n $ipaddr "rm -rf /var/log/ambari*"
        ssh -n $ipaddr "rm -rf /etc/yum.repos.d/ambari*"
        ssh -n $ipaddr "systemctl daemon-reload"
    done
}

# 清理所有服务器上的 hadoop 服务
function clean_hadoop() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "yum remove -y atlas-metadata*" || true
        ssh -n $ipaddr "yum remove -y bigtop-jsvc*" || true
        ssh -n $ipaddr "yum remove -y dolphinscheduler*" || true
        ssh -n $ipaddr "yum remove -y doris*" || true
        ssh -n $ipaddr "yum remove -y flink*" || true
        ssh -n $ipaddr "yum remove -y hadoop*" || true
        ssh -n $ipaddr "yum remove -y hbase*" || true
        ssh -n $ipaddr "yum remove -y hive*" || true
        ssh -n $ipaddr "yum remove -y hue*" || true
        ssh -n $ipaddr "yum remove -y impala*" || true
        ssh -n $ipaddr "yum remove -y kafka*" || true
        ssh -n $ipaddr "yum remove -y knox*" || true
        ssh -n $ipaddr "yum remove -y kudu*" || true
        ssh -n $ipaddr "yum remove -y kyuubi*" || true
        ssh -n $ipaddr "yum remove -y livy2*" || true
        ssh -n $ipaddr "yum remove -y ozone*" || true
        ssh -n $ipaddr "yum remove -y phoenix*" || true
        ssh -n $ipaddr "yum remove -y ranger*" || true
        ssh -n $ipaddr "yum remove -y seatunnel*" || true
        ssh -n $ipaddr "yum remove -y spark2*" || true
        ssh -n $ipaddr "yum remove -y spark3*" || true
        ssh -n $ipaddr "yum remove -y spark-atlas-connector*" || true
        ssh -n $ipaddr "yum remove -y sqoop*" || true
        ssh -n $ipaddr "yum remove -y tez*" || true
        ssh -n $ipaddr "yum remove -y zookeeper*" || true

        ssh -n $ipaddr "rm -rf /etc/atlas-metadata*"
        ssh -n $ipaddr "rm -rf /etc/bigtop-jsvc*"
        ssh -n $ipaddr "rm -rf /etc/dolphinscheduler*"
        ssh -n $ipaddr "rm -rf /etc/doris*"
        ssh -n $ipaddr "rm -rf /etc/flink*"
        ssh -n $ipaddr "rm -rf /etc/hadoop*"
        ssh -n $ipaddr "rm -rf /etc/hbase*"
        ssh -n $ipaddr "rm -rf /etc/hive*"
        ssh -n $ipaddr "rm -rf /etc/hue*"
        ssh -n $ipaddr "rm -rf /etc/impala*"
        ssh -n $ipaddr "rm -rf /etc/kafka*"
        ssh -n $ipaddr "rm -rf /etc/knox*"
        ssh -n $ipaddr "rm -rf /etc/kudu*"
        ssh -n $ipaddr "rm -rf /etc/kyuubi*"
        ssh -n $ipaddr "rm -rf /etc/livy2*"
        ssh -n $ipaddr "rm -rf /etc/ozone*"
        ssh -n $ipaddr "rm -rf /etc/phoenix*"
        ssh -n $ipaddr "rm -rf /etc/ranger*"
        ssh -n $ipaddr "rm -rf /etc/seatunnel*"
        ssh -n $ipaddr "rm -rf /etc/spark2*"
        ssh -n $ipaddr "rm -rf /etc/spark3*"
        ssh -n $ipaddr "rm -rf /etc/spark-atlas-connector*"
        ssh -n $ipaddr "rm -rf /etc/sqoop*"
        ssh -n $ipaddr "rm -rf /etc/tez*"
        ssh -n $ipaddr "rm -rf /etc/zookeeper*"

        ssh -n $ipaddr "rm -rf /var/log/atlas-metadata*"
        ssh -n $ipaddr "rm -rf /var/log/bigtop-jsvc*"
        ssh -n $ipaddr "rm -rf /var/log/dolphinscheduler*"
        ssh -n $ipaddr "rm -rf /var/log/doris*"
        ssh -n $ipaddr "rm -rf /var/log/flink*"
        ssh -n $ipaddr "rm -rf /var/log/hadoop*"
        ssh -n $ipaddr "rm -rf /var/log/hbase*"
        ssh -n $ipaddr "rm -rf /var/log/hive*"
        ssh -n $ipaddr "rm -rf /var/log/hue*"
        ssh -n $ipaddr "rm -rf /var/log/impala*"
        ssh -n $ipaddr "rm -rf /var/log/kafka*"
        ssh -n $ipaddr "rm -rf /var/log/knox*"
        ssh -n $ipaddr "rm -rf /var/log/kudu*"
        ssh -n $ipaddr "rm -rf /var/log/kyuubi*"
        ssh -n $ipaddr "rm -rf /var/log/livy2*"
        ssh -n $ipaddr "rm -rf /var/log/ozone*"
        ssh -n $ipaddr "rm -rf /var/log/phoenix*"
        ssh -n $ipaddr "rm -rf /var/log/ranger*"
        ssh -n $ipaddr "rm -rf /var/log/seatunnel*"
        ssh -n $ipaddr "rm -rf /var/log/spark2*"
        ssh -n $ipaddr "rm -rf /var/log/spark3*"
        ssh -n $ipaddr "rm -rf /var/log/spark-atlas-connector*"
        ssh -n $ipaddr "rm -rf /var/log/sqoop*"
        ssh -n $ipaddr "rm -rf /var/log/tez*"
        ssh -n $ipaddr "rm -rf /var/log/zookeeper*"
        
        ssh -n $ipaddr "rm -rf /usr/hdp"
        ssh -n $ipaddr "rm -rf /usr/share/hive"
        ssh -n $ipaddr "rm -rf /usr/share/java"
        ssh -n $ipaddr "rm -rf /usr/lib/hadoop"
        ssh -n $ipaddr "rm -rf /usr/bin/hadoop"

        ssh -n $ipaddr "systemctl daemon-reload"
    done
}

# 清理数据
function clean_data() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "rm -rf /data/*"
        ssh -n $ipaddr "rm -rf /hadoop/*"
        ssh -n $ipaddr "rm -rf /tmp/*"
    done
}

function main() {
    echo -e "$CSTART>unsafe_clean.sh$CEND"

    echo -e "$CSTART>>identification$CEND"
    identification

    echo -e "$CSTART>>clean_java$CEND"
    clean_java || true

    echo -e "$CSTART>>clean_mysql$CEND"
    clean_mysql || true

    echo -e "$CSTART>>clean_ambari$CEND"
    clean_ambari || true

    echo -e "$CSTART>>clean_hadoop$CEND"
    clean_hadoop || true

    echo -e "$CSTART>>clean_data$CEND"
    clean_data || true
}

main
