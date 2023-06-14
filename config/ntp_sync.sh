#!/bin/bash

status=`timedatectl | grep "NTP synchronized:" | awk '{print $3}'`

if [[ $status =~ 'yes' ]];

then
echo '时间服务正常';
else
echo  "时间服务异常";
systemctl stop ntpd
ntpd -gq
systemctl start ntpd

fi
