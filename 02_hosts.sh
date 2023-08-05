#!/bin/bash

#author: Sen Du
#email: dusen@gennlife.com
#created: 2023-04-16 11:00:00
#updated: 2023-04-16 11:00:00

set -e 
source 00_env

# 配置所有节点的 hosts
function config_hosts() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do 
        echo -e "$CSTART>>>>$ipaddr [$(date +'%Y-%m-%d %H:%M:%S')]$CEND"
        scp config/hosts $ipaddr:/etc/
    done
}

# 配置所有节点的 hostname
function config_hostname() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr [$(date +'%Y-%m-%d %H:%M:%S')]$CEND"
        ssh -n $ipaddr "hostname $name"
        ssh -n $ipaddr "hostnamectl set-hostname $name"
        ssh -n $ipaddr "echo '$name' > /etc/hostname"
        ssh -n $ipaddr "echo 'hostname=$name' > /etc/sysconfig/network"
    done
}

function main() {
    echo -e "$CSTART>02_hosts.sh$CEND"
    echo -e "$CSTART>>config_hosts$CEND"
    config_hosts

    echo -e "$CSTART>>config_hostname$CEND"
    config_hostname
}

main
