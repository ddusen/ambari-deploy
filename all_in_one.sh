#!/bin/bash

#author: Sen Du
#email: dusen.me@gmail.com
#created: 2023-04-16 10:00:00
#updated: 2023-04-16 10:00:00

set -e 
source 00_env

# all in one
function main() {
    /bin/bash ./01_sshpass.sh
    /bin/bash ./02_hosts.sh
    /bin/bash ./03_init.sh
    /bin/bash ./04_httpd.sh
    /bin/bash ./05_java.sh
    /bin/bash ./06_chrony.sh
    /bin/bash ./07_mysql.sh
    /bin/bash ./08_ambari_agent.sh
    /bin/bash ./09_ambari_server.sh
    /bin/bash ./10_hdp.sh
}

main
