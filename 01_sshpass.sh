#!/bin/bash

#author: Sen Du
#email: dusen@gennlife.com
#created: 2023-06-22 10:00:00
#updated: 2023-06-22 10:00:00

set -e 
source 00_env

# 安装sshpass
function install_sshpass() {
    echo -e "$CSTART>>>>$(hostname -I)$CEND"
    
    system_version="$(cat /etc/centos-release | sed 's/ //g')"
    echo -e "$CSTART>>>>$(hostname -I)>$system_version$CEND"

    if [[ "$system_version" == RockyLinuxrelease8* ]]; then
        rpm -Uvh rpms/rocky8/epel-release-8-19.el8.noarch.rpm || true
        rpm -Uvh rpms/rocky8/sshpass-1.09-4.el8.x86_64.rpm || true
        
    elif [[ "$system_version" == CentOSLinuxrelease7* ]]; then
        rpm -Uvh rpms/centos7/epel-release-7-14.noarch.rpm || true
        rpm -Uvh rpms/centos7/sshpass-1.06-2.el7.x86_64.rpm || true
    else 
        echo "系统版本[$system_version]超出脚本处理范围" && false
    fi
}

# 配置免密
function config_sshpass() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        sshpass -p $passwd ssh-copy-id -o StrictHostKeyChecking=no $ipaddr
    done
}

function main() {	
    echo -e "$CSTART>01_sshpass.sh$CEND"

    echo -e "$CSTART>>install_sshpass$CEND"
    install_sshpass

    echo -e "$CSTART>>config_sshpass$CEND"
    config_sshpass
}

main
