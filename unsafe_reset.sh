#!/bin/bash

#author: Sen Du
#email: dusen@gennlife.com
#created: 2023-07-05 10:00:00
#updated: 2023-07-05 10:00:00

set -e 
source 00_env

# unsafe reset
function main() {
    /bin/bash ./unsafe_clean.sh
    /bin/bash ./all_in_one.sh
}

main
