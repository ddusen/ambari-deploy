#!/bin/bash

#author: Sen Du
#email: dusen@gennlife.com
#created: 2023-06-19 10:00:00
#updated: 2023-06-19 10:00:00

set -e 
source 00_env

# 安装一些基础软件，便于后续操作
function install_base() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do 
        echo -e "$CSTART>>>>$ipaddr$CEND"

        system_version=$(ssh -n $ipaddr "cat /etc/centos-release | sed 's/ //g'")
        echo -e "$CSTART>>>>$ipaddr>$system_version$CEND"

        if [[ "$system_version" == RockyLinuxrelease8* ]]; then
            scp config/my_config.h $ipaddr:/usr/include/mysql/my_config.h
            ssh -n $ipaddr "yum install mysql-devel" || true
        elif [[ "$system_version" == CentOSLinuxrelease7* ]]; then
            scp rpms/centos7/libtirpc-devel-0.2.4-0.16.el7.x86_64.rpm $ipaddr:/tmp/
            ssh -n $ipaddr "rpm -Uvh /tmp/libtirpc-devel-0.2.4-0.16.el7.x86_64.rpm" || true
        fi
    done
}

# 配置 ambari repos
function config_repos() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        scp config/ambari.repo $ipaddr:/etc/yum.repos.d/ambari.repo
        ssh -n $ipaddr "sed -i 's/TODO_SERVER_IP/$LocalIp/g' /etc/yum.repos.d/ambari.repo"
        ssh -n $ipaddr "yum clean all && yum makecache && yum repolist"
    done
}

# 安装 agent
function install_agent() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "yum install -y ambari-agent" || true
    done
}

# 配置 agent
function config_agent() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        scp config/ambari-agent.ini $ipaddr:/etc/ambari-agent/conf/ambari-agent.ini
        ssh -n $ipaddr "sed -i 's/TODO_SERVER_IP/$LocalIp/g' /etc/ambari-agent/conf/ambari-agent.ini"
    done
}

# 启动 agent
function start_agent() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "ambari-agent start" || true
    done
}

function main() {
    echo -e "$CSTART>09_ambari_agent.sh$CEND"

    echo -e "$CSTART>>install_base$CEND"
    install_base

    echo -e "$CSTART>>config_repos$CEND"
    config_repos

    echo -e "$CSTART>>install_agent$CEND"
    install_agent

    echo -e "$CSTART>>config_agent$CEND"
    config_agent

    echo -e "$CSTART>>start_agent$CEND"
    start_agent

}

main
