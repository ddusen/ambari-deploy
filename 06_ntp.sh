#!/bin/bash

#author: Sen Du
#email: dusen@gennlife.com
#created: 2023-04-16 14:00:00
#updated: 2023-04-16 14:00:00

set -e 
source 00_env

# 备份 ntp config
function backup_ntp_config() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "cp /etc/ntp.conf /etc/ntp.conf.bak" || true
    done
}

# 移除旧版本 ntp
function remove_old_ntp() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "yum remove -y chrony ntp"
    done
}

# 安装 ntp
function install_ntp() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        scp rpms/autogen-libopts-5.18-5.el7.x86_64.rpm $ipaddr:/tmp/
        scp rpms/ntpdate-4.2.6p5-29.el7.centos.2.x86_64.rpm $ipaddr:/tmp/
        scp rpms/ntp-4.2.6p5-29.el7.centos.2.x86_64.rpm $ipaddr:/tmp/

        ssh -n $ipaddr "rpm -Uvh /tmp/autogen-libopts-5.18-5.el7.x86_64.rpm" || true
        ssh -n $ipaddr "rpm -Uvh /tmp/ntpdate-4.2.6p5-29.el7.centos.2.x86_64.rpm" || true
        ssh -n $ipaddr "rpm -Uvh /tmp/ntp-4.2.6p5-29.el7.centos.2.x86_64.rpm" || true
    done
}

# 配置 ntp clients
function config_ntp_clients() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        scp config/ntp_clients $ipaddr:/etc/ntp.conf
        ssh -n $ipaddr "sed -i 's/TODO_SERVER_IP/$LocalIp/g' /etc/ntp.conf"
    done
}

# 配置 ntp server
function config_ntp_server() {
    echo -e "$CSTART>>>>$(hostname -I)$CEND"
    cp config/ntp_server /etc/ntp.conf
    sed -i "s/TODO_SERVER_IP/$(echo $LocalIp | awk -F. '{OFS="."; $NF=0; print}')/g" /etc/ntp.conf
}

# 重启 ntp 服务
function restart_ntp() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "systemctl restart ntpd; systemctl enable ntpd; chkconfig ntpd on; timedatectl set-ntp true"
    done
}

# 强制刷新 ntp，使用 crontab
function force_refresh_ntp() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "mkdir -p /root/scripts/"
        scp config/ntp_sync.sh $ipaddr:/root/scripts/
        ssh -n $ipaddr "chmod +x /root/scripts/ntp_sync.sh"
        ssh -n $ipaddr "(crontab -u $(whoami) -l; echo '*/15 * * * *  /bin/bash /root/scripts/ntp_sync.sh' ) | crontab -u $(whoami) -"
    done
}

function main() {
    echo -e "$CSTART>06_ntp.sh$CEND"

    echo -e "$CSTART>>backup_ntp_config$CEND"
    backup_ntp_config
    
    echo -e "$CSTART>>remove_old_ntp$CEND"
    remove_old_ntp

    echo -e "$CSTART>>install_ntp$CEND"
    install_ntp

    echo -e "$CSTART>>config_ntp_clients$CEND"
    config_ntp_clients

    echo -e "$CSTART>>config_ntp_server$CEND"
    config_ntp_server

    echo -e "$CSTART>>restart_ntp$CEND"
    restart_ntp

    #echo -e "$CSTART>>force_refresh_ntp$CEND"
    #force_refresh_ntp
}

main
