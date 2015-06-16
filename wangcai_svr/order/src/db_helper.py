# -*- coding: utf-8 -*-

#import MySQLdb
import pymysql
MySQLdb = pymysql

import time
import logging
from config import *
from data_types import *

logger = logging.getLogger('db_helper')

conn = MySQLdb.connect(host=MYSQL_HOST, user=MYSQL_USER, passwd=MYSQL_PASSWD, db=MYSQL_DB, charset='utf8')

def insert_order_base(order):
    stmt = "INSERT INTO order_base  \
                SET userid = %d, \
                device_id = '%s', \
                type = %d, \
                serial_num = '%s', \
                money = %d, \
                status = %d, \
                create_time = NOW()" \
                % (order.userid,
                        MySQLdb.escape_string(order.device_id),
                        order.type,
                        MySQLdb.escape_string(order.serial_num),
                        order.money,
                        order.status)
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    cur.execute(stmt)
    conn.commit()


def create_order_alipay_transfer(order):
    stmt = "INSERT INTO order_alipay_transfer \
                SET userid = %d, \
                device_id = '%s', \
                serial_num = '%s', \
                alipay_account = '%s', \
                money = %d, \
                create_time = NOW(), \
                confirm_time = 0, \
                operate_time = 0" \
                % (order.userid,
                        MySQLdb.escape_string(order.device_id),
                        MySQLdb.escape_string(order.serial_num),
                        MySQLdb.escape_string(order.alipay_account),
                        order.money)
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    cur.execute(stmt)
    conn.commit()


def create_order_phone_payment(order):
    stmt = "INSERT INTO order_phone_payment \
                SET userid = %d, \
                device_id = '%s', \
                serial_num = '%s', \
                phone_num = '%s', \
                money = %d, \
                create_time = NOW(), \
                confirm_time = 0, \
                operate_time = 0" \
                % (order.userid,
                        MySQLdb.escape_string(order.device_id),
                        MySQLdb.escape_string(order.serial_num),
                        MySQLdb.escape_string(order.phone_num),
                        order.money)
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    cur.execute(stmt)
    conn.commit()


def create_order_exchange_code(order):
    stmt = "INSERT INTO order_exchange_code \
                SET userid = %d, \
                device_id = '%s', \
                serial_num = '%s', \
                money = %d, \
                status = %d, \
                exchange_type = %d, \
                exchange_code = '%s', \
                create_time = NOW(), \
                confirm_time = NOW(), \
                operate_time = NOW()" \
                % (order.userid,
                        MySQLdb.escape_string(order.device_id),
                        MySQLdb.escape_string(order.serial_num),
                        order.money,
                        order.status,
                        order.exchange_type,
                        MySQLdb.escape_string(order.exchange_code))
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    cur.execute(stmt)
    conn.commit()


def count_available_exchange_code_jingdong():
    stmt = "SELECT COUNT(*) FROM exchange_code_jingdong WHERE status = 0"
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor()
    cur.execute(stmt)
    res = cur.fetchone()
    return int(res[0]) 


def get_available_exchange_code_jingdong():
    stmt = "SELECT code FROM exchange_code_jingdong WHERE status = 0 LIMIT 1"
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(False)
    cur = conn.cursor()
    n = cur.execute(stmt)
    if n == 0:
        return ''
    else:
        res = cur.fetchone()
        code = res[0]
        stmt = "UPDATE exchange_code_jingdong SET status = 1 WHERE code = '%s'" %code
        logger.debug(stmt)
        cur.execute(stmt)
        conn.commit()
        return code


def update_status_exchange_code_jingdong(code):
    stmt = "UPDATE exchange_code_jingdong SET status = 1 WHERE code = '%s'" \
                %MySQLdb.escape_string(code)
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    n = cur.execute(stmt)
    conn.commit()


def count_available_exchange_code_xlvip():
    stmt = "SELECT COUNT(*) FROM exchange_code_xlvip WHERE status = 0"
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor()
    cur.execute(stmt)
    res = cur.fetchone()
    return int(res[0]) 


def get_available_exchange_code_xlvip():
    stmt = "SELECT code FROM exchange_code_xlvip WHERE status = 0 LIMIT 1"
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(False)
    cur = conn.cursor(False)
    n = cur.execute(stmt)
    if n == 0:
        return ''
    else:
        res = cur.fetchone()
        code = res[0]
        stmt = "UPDATE exchange_code_xlvip SET status = 1 WHERE code = '%s'" %code
        logger.debug(stmt)
        cur.execute(stmt)
        conn.commit()
        return code


def update_status_exchange_code_xlvip(code):
    stmt = "UPDATE exchange_code_xlvip SET status = 1 WHERE code = '%s'" \
                %MySQLdb.escape_string(code)
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    n = cur.execute(stmt)
    conn.commit()


def query_order_base(userid, serial_num):
    stmt = "SELECT * FROM order_base WHERE userid = %d AND serial_num = '%s'" \
                % (userid, MySQLdb.escape_string(serial_num))
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        res = cur.fetchone()
        order = Order()
        order.userid = userid
        order.device_id = res['device_id']
        order.serial_num = serial_num
        order.type = int(res['type'])
        order.money = int(res['money'])
        order.status = int(res['status'])
        return order


def query_order_alipay_transfer(userid, serial_num):
    stmt = "SELECT * FROM order_alipay_transfer WHERE userid = %d AND serial_num = '%s'" \
                % (userid, MySQLdb.escape_string(serial_num))
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        res = cur.fetchone()
        order = OrderAlipayTransfer()
        order.userid = userid
        order.device_id = res['device_id']
        order.serial_num = serial_num
        order.money = int(res['money'])
        order.status = int(res['status'])
        order.create_time = str(res['create_time'])
        order.confirm_time = str(res['confirm_time'])
        order.operate_time = str(res['operate_time'])
        order.alipay_account = res['alipay_account']
        order.exchange_type = ExchangeType.T_ALIPAY
        return order


def query_order_phone_payment(userid, serial_num):
    stmt = "SELECT * FROM order_phone_payment WHERE userid = %d AND serial_num = '%s'" \
                % (userid, MySQLdb.escape_string(serial_num))
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        res = cur.fetchone()
        order = OrderPhonePayment()
        order.userid = userid
        order.device_id = res['device_id']
        order.serial_num = serial_num
        order.money = int(res['money'])
        order.status = int(res['status'])
        order.create_time = str(res['create_time'])
        order.confirm_time = str(res['confirm_time'] or '')
        order.operate_time = str(res['operate_time'] or '')
        order.phone_num = res['phone_num']
        order.exchange_type = ExchangeType.T_PHONEPAY
        return order


def query_order_exchange_code(userid, serial_num):
    stmt = "SELECT * FROM order_exchange_code WHERE userid = %d AND serial_num = '%s'" \
                % (userid, MySQLdb.escape_string(serial_num))
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        res = cur.fetchone()
        order = OrderExchangeCode()
        order.userid = userid
        order.device_id = res['device_id']
        order.serial_num = serial_num
        order.money = int(res['money'])
        order.status = int(res['status'])
        order.create_time = str(res['create_time'])
        order.confirm_time = str(res['confirm_time'] or '')
        order.operate_time = str(res['operate_time'] or '')
        order.exchange_type = int(res['exchange_type'])
        order.exchange_code = res['exchange_code']
        return order


def query_order_list(offset, num):
    stmt = "SELECT * FROM order_base WHERE status != %d AND create_time > '2014-01-27'\
                ORDER BY id DESC LIMIT %d, %d" \
                % (OrderStatus.S_OPERATED, offset, num)
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return []
    else:
        order_list = []
        for each in cur.fetchall():
            order = Order()
            order.userid = int(each['userid'])
            order.device_id = each['device_id']
            order.serial_num = each['serial_num']
            order.type = int(each['type'])
            order.money = int(each['money'])
            order.status = int(each['status'])
            order.create_time = str(each['create_time'])
            order_list.append(order)
        return order_list


def query_order_list_alipay_transfer(offset, num):
    stmt = "SELECT * FROM order_alipay_transfer WHERE status != %d \
                ORDER BY id DESC LIMIT %d, %d" \
                % (OrderStatus.S_OPERATED, offset, num)
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return []
    else:
        order_list = []
        for each in cur.fetchall():
            order = OrderAlipayTransfer()
            order.userid = int(each['userid'])
            order.device_id = each['device_id']
            order.serial_num = each['serial_num']
            order.alipay_account = each['alipay_account']
            order.money = int(each['money'])
            order.status = int(each['status'])
            order.create_time = str(each['create_time'])
            order.confirm_time = str(each['confirm_time'] or '')
            order.operate_time = str(each['operate_time'] or '')
            order_list.append(order)
        return order_list


def query_order_list_phone_payment(offset, num):
    stmt = "SELECT * FROM order_phone_payment WHERE status != %d \
                ORDER BY id DESC LIMIT %d, %d" \
                % (OrderStatus.S_OPERATED, offset, num)
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return []
    else:
        order_list = []
        for each in cur.fetchall():
            order = OrderPhonePayment()
            order.userid = int(each['userid'])
            order.device_id = each['device_id']
            order.serial_num = each['serial_num']
            order.money = int(each['money'])
            order.status = int(each['status'])
            order.create_time = str(each['create_time'])
            order.confirm_time = str(each['confirm_time'] or '')
            order.operate_time = str(each['operate_time'] or '')
            order.phone_num = each['phone_num']
            order_list.append(order)
        return order_list


def update_status_order_base(userid, serial_num, status):
    stmt = "UPDATE order_base SET status = %d \
                WHERE userid = %d AND serial_num = '%s'" \
                % (status, userid, MySQLdb.escape_string(serial_num))
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    cur.execute(stmt)
    conn.commit()


def confirm_order_alipay_transfer(userid, serial_num):
    stmt = "UPDATE order_alipay_transfer \
                SET status = %d, confirm_time = NOW(), operate_time = NOW() \
                WHERE userid = %d AND serial_num = '%s'" \
                % (OrderStatus.S_OPERATED, userid, MySQLdb.escape_string(serial_num))
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    n = cur.execute(stmt)
    conn.commit()
    return n


def confirm_order_phone_payment(userid, serial_num):
    stmt = "UPDATE order_phone_payment \
                SET status = %d, confirm_time = NOW(), operate_time = NOW() \
                WHERE userid = %d AND serial_num = '%s'" \
                % (OrderStatus.S_OPERATED, userid, MySQLdb.escape_string(serial_num))
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    n = cur.execute(stmt)
    conn.commit()
    return n
