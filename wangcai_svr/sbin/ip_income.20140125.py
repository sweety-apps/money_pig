#!/bin/env python
# -*- coding: utf-8 -*-
# IP与收入统计

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

#import MySQLdb
import pymysql
MySQLdb = pymysql

import logging
from logging.handlers import RotatingFileHandler

logger = logging.getLogger()


def convert_ts(ts):
    t = ts.split(':')
    return '%s:%02d' %(t[0], int(t[1])/5*5)

def init_login_history():
    mm = {}
    last_ts = ''
    conn = MySQLdb.connect('localhost', 'root', '', db='wangcai')
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("SELECT * FROM login_history_20140125 WHERE DATE(ts) = '2014-01-25'")
    for each in cur.fetchall():
        device_id = each['device_id']
        ip = each['ip']
        ts = convert_ts(str(each['ts']))
        if ts in mm:
            mm[ts][device_id] = ip
        else:
            mm[ts] = {device_id: ip}
        if last_ts in mm:
            for k, v in mm[last_ts].items():
                if k not in mm[ts]:
                    mm[ts][k] = v
        last_ts = ts
    cur.close()
    conn.close()
    return mm

def billing_log():
    conn = MySQLdb.connect('localhost', 'root', '', db='wangcai_billing')
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
#    n = cur.execute("SELECT * FROM billing_log")
#    n = cur.execute("SELECT * FROM billing_log WHERE DATE(insert_time) = '2014-01-26' AND remark LIKE '体验%%'")
    n = cur.execute("SELECT * FROM billing_log WHERE DATE(insert_time) = '2014-01-25' AND money > 0")
    for each in cur.fetchall():
        yield {
            'device_id': each['device_id'], 
            'money': int(each['money']),
            'ts': str(each['ts'])
        }
    cur.close()
    conn.close()


if __name__ == '__main__':
    mm = {}
    login_history = init_login_history()
    for each in billing_log():
        device_id = each['device_id']
        money = each['money']
        ts = convert_ts(each['ts'])
        if ts in login_history:
            if device_id not in login_history[ts]:
                continue
            ip = login_history[ts][device_id]
            if ts not in mm:
                mm[ts] = {ip: money}
            elif ip not in mm[ts]:
                mm[ts][ip] = money
            else:
                mm[ts][ip] += money
            
    for k, v in sorted(mm.items(), key=lambda d:d[0]):
        print k, len(v), sum(v.values())



