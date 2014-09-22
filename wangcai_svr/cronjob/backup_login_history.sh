#!/bin/bash
# 备份昨天的登陆历史

MYSQL="mysql wangcai"

yesterday=`date -d '1 day ago' +"%Y%m%d"`

echo "CREATE TABLE IF NOT EXISTS login_history_$yesterday SELECT * FROM login_history WHERE ts < CURDATE()" | $MYSQL

echo "DELETE FROM login_history WHERE ts < CURDATE()" | $MYSQL


