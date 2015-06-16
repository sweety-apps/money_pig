#!/bin/env python
# -*- coding: utf-8 -*-
# 自动完成订单 规则:单手机号7天内小于50,单日总小于2000

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import os
import time
import json
import urllib
import urllib2
import socket
#import MySQLdb
import pymysql
MySQLdb = pymysql

import logging
from logging.handlers import RotatingFileHandler

logger = logging.getLogger()

def init_logger(path, level=logging.NOTSET, maxBytes=50*1024*1024, backupCount=20):
    logger = logging.getLogger()
    logger.setLevel(level)
    file_handler = RotatingFileHandler(path, maxBytes=maxBytes, backupCount=backupCount)
    file_handler.setFormatter(logging.Formatter("[%(asctime)s] [%(levelname)s] %(message)s", "%Y%m%d %H:%M:%S"))
    logger.addHandler(file_handler)


def make_request(url, method='GET', data={}, timeout=3):
    if method.upper() == 'GET':
        req = urllib2.Request(url + '?' + urllib.urlencode(data))
    else:
        req = urllib2.Request(url, urllib.urlencode(data))

    try:
        resp = urllib2.urlopen(req, timeout = timeout).read()
#            resp = resp.decode('gbk').encode('utf-8')
        logger.debug('resp: %s' %resp)
        return json.loads(resp)
    except urllib2.HTTPError, e:
        return {'rtn': -e.code}
    except urllib2.URLError, e:
        if isinstance(e.reason, socket.timeout):
            return {'rtn': -1}
        else:
            return {'rtn': -2}

def list_order(num):
    url = 'http://127.0.0.1:19866/order/list'
    resp = make_request(url, data={'num':num})
    if resp['rtn'] != 0:
        logger.error('list error!! rtn:%d', resp['rtn'])
    else:
        for each in resp['order_list']:
            yield each

def alipay_perform(userid, order_id):
    url = 'http://127.0.0.1:19866/order/alipay/perform'
    data = {'userid':userid, 'order_id': order_id}
    print url, str(data)
    #return
    resp = make_request(url, 'POST', data)
    if resp['rtn'] != 0:
        logger.error('alipay perform failed!! rtn:%d' %(resp['rtn']))
        print '支付宝转账失败, userid:%d, order_id:%s' %(userid, order_id)
        if 'msg' in resp:
            logger.error('msg: %s' %resp['msg'])
    else:
        logger.info('alipay perform successfully, userid:%d, order_id:%s' %(userid, order_id))
        print '支付宝转账成功, userid:%d, order_id:%s' %(userid, order_id)
        time.sleep(1)

def phone_charge(userid, order_id):
    url = 'http://127.0.0.1:19866/order/phone/charge'
    data = {'userid':userid, 'order_id': order_id}
    print url, str(data)
    resp = make_request(url, 'POST', data)
    if resp['rtn'] != 0:
        logger.error('phone charge failed!! rtn:%d', resp['rtn'])
        print '话费充值成功, userid:%d, order_id:%s' %(userid, order_id)
        if 'msg' in resp:
            print 'msg: %s' %resp['msg']
    else:
        logger.info('phone charge successfully, userid:%d, order_id:%s' %(userid, order_id))
        print '话费充值成功, userid:%d, order_id:%s' %(userid, order_id)
        time.sleep(1)

def total_withdraw_today():
    conn = MySQLdb.connect('localhost', 'root', '', db='wangcai_order')
    cur = conn.cursor()
    cur.execute('SELECT SUM(money) FROM order_base \
            WHERE ts > CURDATE() AND type IN (1, 2) AND status = 2')
    res = cur.fetchone()
    n = int(res[0] or 0)/100
    cur.close()
    conn.close()
    return n

def user_withdraw_today(userid):
    conn = MySQLdb.connect('localhost', 'root', '', db='wangcai_order')
    cur = conn.cursor()
    cur.execute('SELECT SUM(money) FROM order_base \
            WHERE userid = %d AND create_time > CURDATE() \
            AND type IN (1, 2) AND status = 2' %userid)
    res = cur.fetchone()
    n = int(res[0] or 0)/100
    cur.close()
    conn.close()
    return n

def user_withdraw_weekly(userid):
    conn = MySQLdb.connect('localhost', 'root', '', db='wangcai_order')
    cur = conn.cursor()
    cur.execute('SELECT SUM(money) FROM order_base \
            WHERE userid = %d AND create_time > DATE_SUB(CURDATE(), INTERVAL 7 DAY) \
            AND type IN (1, 2) AND status = 2' %userid)
    res = cur.fetchone()
    n = int(res[0] or 0)/100
    cur.close()
    conn.close()
    return n

def commit_order(order):
    assert order['type'] in [1, 2]
    n = user_withdraw_today(order['userid'])
    nn = user_withdraw_weekly(order['userid'])
    limit = 100
    if n > limit:
        logger.info('用户[%d] 当日内提现超过%d！暂停自动发放' %(order['userid']))
        print '用户[%d] 当日内提现超过%d！暂停自动发放' %(order['userid'], limit)
    elif nn > 200:
        logger.info('用户[%d] 7日内提现超过200元！' %order['userid'])
        print '用户[%d] 7日内提现超过200元！暂停自动发放' %order['userid']
    else:
        print '用户[%d]当天内提现%d元，7日内提现%d元' %(order['userid'], n, nn)
    if order['type'] == 1:
        alipay_perform(order['userid'], order['serial_num'])
    else:
        phone_charge(order['userid'], order['serial_num'])
    

if __name__ == '__main__':
    os.chdir(os.path.dirname(sys.argv[0]))
    print time.strftime('%Y-%m-%d %H:%M:%S',time.localtime())
    init_logger('log/order_auto_commit.log')
    #单日提现不超过5000
    n = total_withdraw_today()
    if n > 5000:
        logger.info('单日提现超过5000元')
        print '单日提现超过5000元！暂停自动发放'
        sys.exit(1)
    else:
        print '单日提现已%d元' %n

    logger.info('Cronjob Test')

    n = 0
    for order in list_order(500):
        if n < 500:
            if order['type'] in [1, 2]:
                commit_order(order)
                n += 1
            else:
                logger.error('unexpect order type, %d' %order['type'])


