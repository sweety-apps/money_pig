#!/bin/env python
# -*- coding: utf-8 -*-

# IP与收入统计

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

#import MySQLdb
import pymysql
MySQLdb = pymysql

import time
import logging
from logging.handlers import RotatingFileHandler

logger = logging.getLogger()


def convert_ts(ts):
    t = ts.split(':')
    return '%s:%02d' %(t[0], int(t[1])/5*5)

def init_login_history(dt):
    mm = {}
    last_ts = ''
    conn = MySQLdb.connect('localhost', 'root', '', db='wangcai')
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    cur.execute("SELECT * FROM login_history WHERE ts > '%s'" %dt)
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

def billing_log(dt):
    conn = MySQLdb.connect('localhost', 'root', '', db='wangcai_billing', charset='utf8')
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute("SELECT * FROM billing_log WHERE DATE(insert_time) = '%s' AND remark LIKE '体验%%'" %dt)
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
    dt = time.strftime('%Y-%m-%d', time.localtime())
    login_history = init_login_history(dt)
    for each in billing_log(dt):
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
        print k, len(v), sum(v.values())/100.0

    sys.exit(1)
    
    m = {}
    for k, v in mm.items():
        for kk, vv in v.items():
            if kk in m:
                m[kk] += vv
            else:
                m[kk] = vv

    for k, v in sorted(m.items(), key=lambda d:d[1], reverse=True):
        print v/100.0, k



