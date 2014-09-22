#!/bin/bash

if [ $# -ne 3 ]; then
  echo "usage: $0 <userid> <device_id> <order_id>"
  exit
fi

userid=$1
order_id=$2

curl 'http://gm.getwangcai.com/order/phone/charge' -d 'userid=10049&order_id=201401231554000000000009fi'

#echo "userid:$userid, device_id:$device_id, serial_num:$serial_num"

#echo "curl 'http://127.0.0.1:15284/confirm_phone_payment' -d 'userid=$userid&'"

#curl 'http://127.0.0.1:15284/confirm_phone_payment' -d 'userid='$userid'&serial_num=$serial_num"

#curl 'http://127.0.0.1:15283/commit' -d "userid=$userid&device_id=$device_id&serial_num=$serial_num"

