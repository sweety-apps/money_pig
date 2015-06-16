#!/bin/bash

if [ $# -ne 1 ]; then
  echo "usage: $0 <code_list.txt>"
  exit
fi

code_list=$1

echo 'mysql -u root -p '' -e "use wangcai_order; load data local infile '$code_list' into table exchange_code_jingdong (code);"'
mysql -u root -p '' -e "use wangcai_order; load data local infile '$code_list' into table exchange_code_jingdong (code);"