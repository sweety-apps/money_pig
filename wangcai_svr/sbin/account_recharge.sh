#!/bin/bash

if [ $# -ne 2 ]; then
  echo "usage: $0 <userid> <money>"
  exit
fi

userid=$1
money=$2

#echo $userid
#echo $money

curl 'http://127.0.0.1:15283/recharge' -d 'device_id=-1&userid='$userid'&money='$money'&remark=GOD&offerwall_money=0'

