#!/bin/bash

if [ $# -lt 2 ]; then
    echo "usage: $0 <device_id> <userid>"
    exit
fi

MYSQL=/usr/local/sbin/my.sh

device_id=$1
userid=$2

echo "DELETE FROM anonymous_device WHERE device_id = '$device_id'" | $MYSQL wangcai

echo "DELETE FROM user_info WHERE id = $userid" | $MYSQL wangcai

echo "DELETE FROM user_device WHERE userid = $userid" | $MYSQL wangcai

echo "DELETE FROM task_of_device WHERE device_id = '$device_id'" | $MYSQL wangcai_task

echo "DELETE FROM task_of_user WHERE userid = $userid" | $MYSQL wangcai_task

echo "DELETE FROM task_daily WHERE device_id = '$device_id' OR userid = $userid" | $MYSQL wangcai_task

echo "DELETE FROM task_invite WHERE userid = $userid" | $MYSQL wangcai_task

echo "DELETE FROM task_app_download WHERE device_id = '$device_id' OR userid = $userid" | $MYSQL wangcai_task

echo "DELETE FROM offer_wall_point WHERE device_id = '$device_id'" | $MYSQL wangcai_task

echo "DELETE FROM anonymous_account WHERE device_id = '$device_id'" | $MYSQL wangcai_billing

echo "DELETE FROM billing_account WHERE userid = $userid" | $MYSQL wangcai_billing

echo "DELETE FROM billing_log WHERE device_id = '$device_id' OR userid = $userid" | $MYSQL wangcai_billing

echo "DELETE FROM billing_transaction WHERE userid = $userid" | $MYSQL wangcai_billing

