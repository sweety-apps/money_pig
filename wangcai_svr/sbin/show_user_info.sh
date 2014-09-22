#!/bin/bash

if [ $# -ne 1 ]; then
  echo "usage $0 <userid>"
  exit
fi

userid=$1

echo "SELECT * FROM user_info WHERE id = $userid \G" | mysql wangcai

echo "SELECT * FROM user_device WHERE userid = $userid \G" | mysql wangcai

echo "SELECT * FROM billing_account WHERE userid = $userid \G" | mysql wangcai_billing

echo "SELECT userid, device_id, serial_num, money, remark, insert_time, err, msg FROM billing_log WHERE userid = $userid" | mysql wangcai_billing

