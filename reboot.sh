#!/bin/bash

#author: Sen Du
#email: dusen.me@gmail.com
#created: 2023-04-16 21:00:00
#updated: 2023-04-16 21:00:00

set -e 
source 00_env

# 避免误操作，添加输入密码步骤
function identification() {
    read -s -p "请输入密码(该操作有风险，请确保清醒): " pswd
    shapswd=$(echo $pswd | sha1sum | head -c 10)
    if [[ "$shapswd" == "e6283c043a" ]]; then
        echo && true
    else
        echo -e "\033[33m密码错误，程序终止！\033[0m"
        echo && false
    fi
}

# 重启机器
function reboot() {
    cat config/vm_info | grep -v "^#" | grep -v "^$" | while read ipaddr name passwd
    do
        echo -e "$CSTART>>>>$ipaddr [$(date +'%Y-%m-%d %H:%M:%S')]$CEND";
        ssh -n $ipaddr "reboot" || true;
    done
}

function main() {
    echo -e "$CSTART>reboot.sh$CEND"

    echo -e "$CSTART>>identification$CEND"
    identification

    echo -e "$CSTART>>reboot$CEND"
    reboot
}

main
