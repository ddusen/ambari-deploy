#!/bin/bash

#author: Sen Du
#email: dusen@gennlife.com
#created: 2023-06-19 10:00:00
#updated: 2023-06-19 10:00:00

set -e 
source 00_env

# 配置 ambari repos
function config_repos() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        
        ssh -n $ipaddr "rm -rf /etc/yum.repos.d/*"
        scp config/default.repo $ipaddr:/etc/yum.repos.d/default.repo
        scp config/ambari.repo $ipaddr:/etc/yum.repos.d/ambari.repo
        scp config/hdp.repo $ipaddr:/etc/yum.repos.d/hdp.repo

        ssh -n $ipaddr "sed -i 's/TODO_SERVER_IP/$LocalIp/g' /etc/yum.repos.d/ambari.repo"
        ssh -n $ipaddr "sed -i 's/TODO_SERVER_IP/$LocalIp/g' /etc/yum.repos.d/hdp.repo"
        
        ssh -n $ipaddr "yum clean all"
        ssh -n $ipaddr "yum makecache"
        ssh -n $ipaddr "yum repolist"
    done
}

function main() {
    echo -e "$CSTART>08_ambari_repos.sh$CEND"
    
    echo -e "$CSTART>>config_repos$CEND"
    config_repos
}

main
