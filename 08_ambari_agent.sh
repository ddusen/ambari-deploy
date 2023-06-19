#!/bin/bash

#author: Sen Du
#email: dusen@gennlife.com
#created: 2023-06-19 10:00:00
#updated: 2023-06-19 10:00:00

set -e 
source 00_env


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
    echo -e "$CSTART>08_ambari_agent.sh$CEND"
    
    echo -e "$CSTART>>install_agent$CEND"
    install_agent

    echo -e "$CSTART>>config_agent$CEND"
    config_agent

    echo -e "$CSTART>>start_agent$CEND"
    start_agent

}

main
