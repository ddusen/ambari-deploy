#!/bin/bash

#author: Sen Du
#email: dusen@gennlife.com
#created: 2023-04-16 14:00:00
#updated: 2023-04-16 14:00:00

set -e 
source 00_env

# 移除 ntp，使用 chrony，避免版本冲突
function remove_ntp() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "yum remove -y ntp" || true
    done
}

# 备份 chrony config
function backup_chrony_config() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "cp /etc/chrony.conf /etc/chrony.conf.bak" || true
    done
}

# 安装 chrony
function install_chrony() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "yum install -y chrony" || true
    done
}

# 配置 chrony clients
function config_chrony_clients() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        scp config/chrony_client $ipaddr:/etc/chrony.conf
        ssh -n $ipaddr "sed -i 's/TODO_SERVER_IP/$LOCAL_IP/g' /etc/chrony.conf"
    done
}

# 配置 chrony server
function config_chrony_server() {
    echo -e "$CSTART>>>>$(hostname -I)$CEND"
    cp config/chrony_server /etc/chrony.conf
    sed -i "s/TODO_SERVER_IP/$(echo $LOCAL_IP | awk -F. '{OFS="."; $NF=0; print}')/g" /etc/chrony.conf
}

# 重启 chrony 服务
function restart_chrony() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        # 设置 chrony timezone
        ssh -n $ipaddr "timedatectl set-timezone 'Asia/Shanghai'" || true
        ssh -n $ipaddr "systemctl restart chronyd" || true
        ssh -n $ipaddr "systemctl enable --now chronyd.service" || true
    done
}

function main() {
    echo -e "$CSTART>06_chrony.sh$CEND"

    echo -e "$CSTART>>remove_ntp$CEND"
    remove_ntp

    echo -e "$CSTART>>backup_chrony_config$CEND"
    backup_chrony_config
    
    echo -e "$CSTART>>install_chrony$CEND"
    install_chrony

    echo -e "$CSTART>>config_chrony_clients$CEND"
    config_chrony_clients

    echo -e "$CSTART>>config_chrony_server$CEND"
    config_chrony_server

    echo -e "$CSTART>>restart_chrony$CEND"
    restart_chrony
}

main
