#!/bin/bash

#author: Sen Du
#email: dusen@gennlife.com
#created: 2023-04-16 15:00:00
#updated: 2023-04-16 15:00:00

set -e 
source 00_env

########################### 此脚本请手动一步一步执行 ###########################

# 1.查看虚拟机磁盘列表
function show_disk() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do 
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "lsblk"
    done
}

# 2.格式化磁盘
function format_disk() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do 
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "mkfs.xfs /dev/vdb"
        ssh -n $ipaddr "mkfs.xfs /dev/vdc"
    done
}

# 3.获取磁盘UUID
function get_disk_uuid() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do 
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "blkid"
    done
}

# 4.修改 /etc/fstab 文件
function modify_fstab() {
    ssh -n 10.0.1.150 "echo 'UUID="fe33ee15-cdb1-43b4-882d-6a28767128f6" /dfs/dn1  xfs     defaults        0 0' >> /etc/fstab"
    ssh -n 10.0.1.150 "echo 'UUID="df1af102-1184-4337-9740-0fe862be4992" /dfs/dn2  xfs     defaults        0 0' >> /etc/fstab"

    ssh -n 10.0.1.151 "echo 'UUID="7b87a224-6dc2-4666-a67e-c66166fafcb4" /dfs/dn1  xfs     defaults        0 0' >> /etc/fstab"
    ssh -n 10.0.1.151 "echo 'UUID="f2eccda8-74be-4879-9885-1871a6312089" /dfs/dn2  xfs     defaults        0 0' >> /etc/fstab"
}

function check_modify_fstab() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do 
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "cat /etc/fstab"
    done
}

# 5.挂载磁盘
function mount_disk() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do 
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "mkdir -p /dfs/dn1"
        ssh -n $ipaddr "mkdir -p /dfs/dn2"
        ssh -n $ipaddr "mount -a"
    done
}

function check_mount() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do 
        echo -e "$CSTART>>>>$ipaddr$CEND"
        ssh -n $ipaddr "df -h"
    done
}
