#!/bin/bash

if [ $# -lt 1 ]; then
  echo "usage: <ip> [<date>]"
  exit
fi

ip=$1
if [ $# -eq 2 ]; then
  dt=$2
fi


echo "SELECT DISTINCT device_id, platform FROM login_history WHERE ip = '$ip'" \
  | my.sh wangcai | sed '1d' \
  | while read dd pp; do
      echo "SELECT device_id, userid, '$pp', money, remark, err, msg, insert_time FROM billing_log WHERE device_id = '$dd'" \
        | my.sh wangcai_billing | sed '1d'
    done

curl "http://ip.cn/index.php?ip=$ip"

