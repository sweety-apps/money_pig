#!/bin/bash

mysql -u root -p "" -e "create database wangcai"
mysql -u root -p "" -e "create database wangcai_billing"
mysql -u root -p "" -e "create database wangcai_order"
mysql -u root -p "" -e "create database wangcai_task"
mysql -u root -p --default-character-set=utf8 wangcai < ../account/sql/user.sql
mysql -u root -p --default-character-set=utf8 wangcai_billing < ../billing/sql/billing.sql
mysql -u root -p --default-character-set=utf8 wangcai < ../interface/sql/sms.sql
mysql -u root -p --default-character-set=utf8 wangcai_order < ../order/sql/order.sql
mysql -u root -p --default-character-set=utf8 wangcai_task < ../task/sql/task.sql
mysql -u root -p --default-character-set=utf8 wangcai_task < ../task/sql/init_task.sql