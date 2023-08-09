#!/bin/bash

#author: Sen Du
#email: dusen@gennlife.com
#created: 2023-04-16 15:00:00
#updated: 2023-04-16 15:00:00

set -e 
source 00_env

function remove_old_mysql() {
    echo -e "$CSTART>>>>$(hostname -I) [$(date +'%Y-%m-%d %H:%M:%S')]$CEND"
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

# 安装 mysql8.0
function install_mysql() {
    echo -e "$CSTART>>>>$(hostname -I) [$(date +'%Y-%m-%d %H:%M:%S')]$CEND"
    
    system_version="$(cat /etc/centos-release | sed 's/ //g')"
    echo -e "$CSTART>>>>$(hostname -I)>$system_version$CEND"

    if [[ "$system_version" == RockyLinuxrelease8* ]]; then
        wget -O /tmp/mysql-8.0-el8-bundle-rpms.tar.gz $HTTPD_SERVER/others/mysql-8.0-el8-bundle-rpms.tar.gz
        tar -zxvf /tmp/mysql-8.0-el8-bundle-rpms.tar.gz -C /tmp/
        yum localinstall -y /tmp/mysql-8.0-el8-bundle-rpms/*.rpm || true # 忽略报错

    elif [[ "$system_version" == CentOSLinuxrelease7* ]]; then
        wget -O /tmp/mysql-8.0-el7-bundle-rpms.tar.gz $HTTPD_SERVER/others/mysql-8.0-el7-bundle-rpms.tar.gz
        tar -zxvf /tmp/mysql-8.0-el7-bundle-rpms.tar.gz -C /tmp/
        yum localinstall -y /tmp/mysql-8.0-el7-bundle-rpms/*.rpm || true # 忽略报错

    else 
        echo "系统版本[$system_version]超出脚本处理范围" && false
    fi
}

# 启动mysql
function start_mysql() {
    echo -e "$CSTART>>>>$(hostname -I) [$(date +'%Y-%m-%d %H:%M:%S')]$CEND"
    systemctl start mysqld.service
    systemctl enable mysqld.service
}

# 配置 mysql8.0
function config_mysql() {
    echo -e "$CSTART>>>>$(hostname -I) [$(date +'%Y-%m-%d %H:%M:%S')]$CEND"
    #默认初始化密码
    default_passwd="$(cat /var/log/mysqld.log | grep 'temporary password' | awk -F ': ' '{print $2}')"
    echo "默认密码：$default_passwd"
    echo "新密码：$MYSQL_ROOT_PASSWD"

    # 自动执行
    printf "n\ny\nn\ny\ny\n" | mysql_secure_installation --password=$default_passwd
}

# 更新数据库，在 mysql 中创建用户，添加新用户和数据库
function update_database() {
    echo -e "$CSTART>>>>$(hostname -I) [$(date +'%Y-%m-%d %H:%M:%S')]$CEND"
    #降低密码难度
    mysql -hlocalhost -uroot -p"$MYSQL_ROOT_PASSWD" -e "SET GLOBAL validate_password.policy=LOW"
    #导入常规用户
    mysql -hlocalhost -uroot -p"$MYSQL_ROOT_PASSWD" -e "SOURCE config/create_dbs.sql"
}

function main() {
    echo -e "$CSTART>07_mysql.sh$CEND"

    echo -e "$CSTART>>remove_old_mysql$CEND"
    remove_old_mysql

    echo -e "$CSTART>>install_mysql$CEND"
    install_mysql

    echo -e "$CSTART>>start_mysql$CEND"
    start_mysql

    echo -e "$CSTART>>config_mysql$CEND"
    config_mysql

    echo -e "$CSTART>>update_database$CEND"
    update_database
}

main
