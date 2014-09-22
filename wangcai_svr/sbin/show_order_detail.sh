#!/bin/bash

if [ $# -ne 2 ]; then
  echo "usage: $0 <userid> <serial_num>"
  exit
fi

userid=$1
serial_num=$2

echo "SELECT type FROM order_base WHERE userid = $userid AND serial_num = '$serial_num'" \
  | mysql wangcai_order \
  | sed '1d' \
  | while read type; do
      if [ $type -eq 1 ]; then
        echo "SELECT * FROM order_alipay_transfer WHERE userid = $userid AND serial_num = '$serial_num' \G" \
          | mysql wangcai_order 
      elif [ $type -eq 2 ]; then
        echo "SELECT * FROM order_phone_payment WHERE userid = $userid AND serial_num = '$serial_num' \G" \
          | mysql wangcai_order
      elif [ $type -eq 3 ]; then
        echo "SELECT * FROM order_exchange_code WHERE userid = $userid AND serial_num = '$serial_num' \G" \
          | mysql wangcai_order
      fi
    done

