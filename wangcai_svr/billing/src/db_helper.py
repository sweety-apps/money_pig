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


def query_anonymous_account(device_id):
    stmt = "SELECT *, UNIX_TIMESTAMP(create_time) AS u_create_time FROM anonymous_account WHERE device_id = '%s'" \
                % MySQLdb.escape_string(device_id)
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        res = cur.fetchone()
        account = AnonymousAccount()
        account.device_id   = device_id
        account.money       = int(res['money'])
        account.flag        = int(res['flag'])
        account.create_time = int(res['u_create_time'])
        return account

def query_billing_account(userid):
    stmt = "SELECT *, UNIX_TIMESTAMP(create_time) AS u_create_time FROM billing_account WHERE userid = %d" %userid
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        res = cur.fetchone()
        account = BillingAccount()
        account.userid      = userid
        account.money       = int(res['money'])
        account.freeze      = int(res['freeze'])
        account.income      = int(res['income'])
        account.outgo       = int(res['outgo'])
        account.shared_income = int(res['shared_income'])
        account.status      = int(res['status'])
        account.create_time = int(res['u_create_time'])
        return account


def activate_billing_account(userid, account):
    stmt = "INSERT IGNORE INTO billing_account \
                SET userid = %d, money = %d, income = %d, create_time = NOW()" \
                % (userid, account.money, account.money)
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(False)
    cur = conn.cursor()
    n = cur.execute(stmt)
    if n == 0:
        stmt = "UPDATE billing_account SET money = money + %d, income = income + %d WHERE userid = %d" \
                    % (account.money, account.money, userid)
        logger.debug(stmt)
        cur.execute(stmt)
    stmt = "UPDATE anonymous_account SET flag = 1 WHERE device_id = '%s'" \
                %MySQLdb.escape_string(account.device_id)
    logger.debug(stmt)
    cur.execute(stmt)
    stmt = "UPDATE billing_log SET userid = %d WHERE device_id = '%s'" \
                % (userid, MySQLdb.escape_string(account.device_id))
    logger.debug(stmt)
    cur.execute(stmt)
    conn.commit()
        

def gen_serial_num():
    def to36(num):
        letters = "0123456789abcdefghijklmnopqrstuvwxyz"
        converted = [] 
        while num != 0:
            num, r = divmod(num, 36)
            converted.insert(0, letters[r])
        return "".join(converted) or '0'
    def make_serial_num(id):
        tm = time.localtime()
        return '%s%s' % (time.strftime('%Y%m%d%H%M%S', tm), to36(id).zfill(12))
    conn.ping(True)
    cur = conn.cursor()
    cur.execute("INSERT INTO billing_serial (id) VALUES (0)")
    id = conn.insert_id()
    conn.commit()
    return make_serial_num(id)


def insert_billing_log(cursor, serial_num, userid, device_id, money, remark):
    stmt = "INSERT INTO billing_log \
            SET serial_num = '%s', userid = %d, device_id = '%s', \
                money = %d, remark = '%s', insert_time = NOW()" \
                % (serial_num, userid, MySQLdb.escape_string(device_id),
                        money, MySQLdb.escape_string(remark))
    logger.debug(stmt)
    cursor.execute(stmt)

def update_log_status(cursor, serial_num, status):
    stmt = "UPDATE billing_log SET status = %d WHERE serial_num = '%s'" %(status, serial_num)
    logger.debug(stmt)
    cursor.execute(stmt)

def update_err_msg(cursor, serial_num, err, msg):
    stmt = "UPDATE billing_log SET err = %d, msg = '%s' WHERE serial_num = '%s'" \
                % (err, MySQLdb.escape_string(msg), serial_num)
    logger.debug(stmt)
    cursor.execute(stmt)


def recharge_anonymous_account(device_id, money, remark):
    serial_num = gen_serial_num()

    conn.autocommit(False)
    cur = conn.cursor()

    #先记log
    insert_billing_log(cur, serial_num, 0, device_id, money, remark)

    #检查账户是否存在
    stmt = "SELECT flag FROM anonymous_account WHERE device_id = '%s'" %MySQLdb.escape_string(device_id)
    logger.debug(stmt)    
    n = cur.execute(stmt)
    if n != 0:
        res = cur.fetchone()
        flag = int(res[0])
        #账户已被绑定
        if flag != 0:
            err = BillingError.E_INVALID_ACCOUNT
            update_err_msg(cur, serial_num, err, BillingError.strerror(err))
            conn.commit()
            return err
        else:
            stmt = "UPDATE anonymous_account \
                        SET money = money + %d WHERE device_id = '%s'" \
                        % (money, MySQLdb.escape_string(device_id))
    else:
        #账户不存在,新建账户
        stmt = "INSERT INTO anonymous_account \
                    SET device_id = '%s', money = %d, create_time = NOW()" \
                    % (MySQLdb.escape_string(device_id), money)
        
    logger.debug(stmt)
    cur.execute(stmt)
    conn.commit()
    return 0


def recharge_billing_account(userid, device_id, money, remark):
    serial_num = gen_serial_num()

    conn.autocommit(False)
    cur = conn.cursor()

    #先记log
    insert_billing_log(cur, serial_num, userid, device_id, money, remark)

    stmt = "SELECT status FROM billing_account WHERE userid = %d" %userid
    logger.debug(stmt)
    n = cur.execute(stmt)
    if n == 0:
        #账户不存在
#        err = BillingError.E_NO_SUCH_ACCOUNT
#        update_err_msg(cur, serial_num, err, BillingError.strerror(err))
        stmt = "INSERT INTO billing_account \
                    SET userid = %d, money = %d, income = %d, create_time = NOW()" \
                    % (userid, money, money)
        logger.debug(stmt)
        cur.execute(stmt)
        conn.commit()
        return 0
    else:
        res = cur.fetchone()
        status = int(res[0])

    stmt = "UPDATE billing_account SET money = money + %d, income = income + %d WHERE userid = %d" \
                % (money, money, userid)
    logger.debug(stmt)
    cur.execute(stmt)
    conn.commit()
    return 0


def freeze_money(userid, device_id, money, remark):
    serial_num = gen_serial_num()

    conn.autocommit(False)
    cur = conn.cursor()

    #先记log
    insert_billing_log(cur, serial_num, userid, device_id, -money, remark)

    stmt = "SELECT money - freeze - %d FROM billing_account WHERE userid = %d" %(money, userid)
    n = cur.execute(stmt)
    if n == 0:
        err = BillingError.E_NO_SUCH_ACCOUNT
        update_err_msg(cur, serial_num, err, BillingError.strerror(err))
        conn.commit()
        return err
    else:
        res = cur.fetchone()
        if int(res[0]) < 0:
            #余额不足
            err = BillingError.E_INSUFFIENT_FUNDS
            update_err_msg(cur, serial_num, err, BillingError.strerror(err))
            conn.commit()
            return err

    stmt = "INSERT INTO billing_transaction \
                SET serial_num = '%s', userid = %d, device_id = '%s', money = %d, remark = '%s'" \
                % (serial_num, 
                        userid, 
                        MySQLdb.escape_string(device_id),
                        money, 
                        MySQLdb.escape_string(remark))
    logger.debug(stmt)
    cur.execute(stmt)
    stmt = "UPDATE billing_account SET freeze = freeze + %d WHERE userid = %d" % (money, userid)
    logger.debug(stmt)
    cur.execute(stmt)
    conn.commit()
    return serial_num


def do_commit(userid, device_id, serial_num):
    conn.autocommit(False)
    conn.ping(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    stmt = "SELECT * FROM billing_transaction WHERE serial_num = '%s'" %MySQLdb.escape_string(serial_num)
    logger.debug(stmt)
    n = cur.execute(stmt)
    if n == 0:
        return BillingError.E_SERIAL_NOT_FOUND
    else:
        res = cur.fetchone()
        txn = BillingTransaction()
        txn.serial_num = serial_num
        txn.userid = int(res['userid'])
        txn.device_id = res['device_id']
        txn.money = int(res['money'])
        txn.status = int(res['status'])
        txn.remark = res['remark']
        if userid != txn.userid or device_id != txn.device_id:
            logger.error('invalid transaction, userid or device_id not match, %d => %d, %s => %s' 
                    %(userid, txn.userid, device_id, txn.device_id))
            return BillingError.E_INVALID_TRANSACTION
        elif txn.status != TransactionStatus.S_PENDING:
            logger.error('invalid transaction, status error, %d' %txn.status)
            return BillingError.E_INVALID_TRANSACTION

    stmt = "UPDATE billing_account SET money = money - %d, freeze = freeze - %d, outgo = outgo + %d WHERE userid = %d" \
                % (txn.money, txn.money, txn.money, userid)
    logger.debug(stmt)
    cur.execute(stmt)
    stmt = "UPDATE billing_transaction SET status = %d WHERE serial_num = '%s'" \
                % (TransactionStatus.S_COMMITTED, MySQLdb.escape_string(serial_num))
    logger.debug(stmt)
    cur.execute(stmt)
    conn.commit()
    return 0


def do_rollback(userid, device_id, serial_num):
    conn.autocommit(False)
    conn.ping(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    stmt = "SELECT * FROM billing_transaction WHERE serial_num = '%s'" %MySQLdb.escape_string(serial_num)
    logger.debug(stmt)
    n = cur.execute(stmt)
    if n == 0:
        return BillingError.E_SERIAL_NOT_FOUND
    else:
        res = cur.fetchone()
        txn = BillingTransaction()
        txn.serial_num = serial_num
        txn.userid = int(res['userid'])
        txn.device_id = res['device_id']
        txn.money = int(res['money'])
        txn.status = int(res['status'])
        txn.remark = res['remark']
        if userid != txn.userid or device_id != txn.device_id:
            logger.error('invalid transaction, userid or device_id not match, %d => %d, %s => %s' 
                    %(userid, txn.userid, device_id, txn.device_id))
            return BillingError.E_INVALID_TRANSACTION
        elif txn.status != TransactionStatus.S_PENDING:
            logger.error('invalid transaction, status error, %d' %txn.status)
            return BillingError.E_INVALID_TRANSACTION

    stmt = "UPDATE billing_account SET freeze = freeze - %d WHERE userid = %d" %(txn.money, userid)
    logger.debug(stmt)
    cur.execute(stmt)
    stmt = "UPDATE billing_transaction SET status = %d WHERE serial_num = '%s'" \
                % (TransactionStatus.S_CANCELLED, MySQLdb.escape_string(serial_num))
    logger.debug(stmt)
    cur.execute(stmt)
    err = BillingError.E_TRANSACTION_CANCELLED
    update_err_msg(cur, serial_num, err, BillingError.strerror(err))
    conn.commit()
    return 0
                

def add_shared_income(userid, money):
    stmt = "UPDATE billing_account \
                SET money = money + %d, \
                income = income + %d, \
                shared_income = shared_income + %d WHERE userid = %d" \
                % (money, money, money, userid)
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    n = cur.execute(stmt)
    conn.commit()
    return n


def query_billing_log(device_id, userid, offset, num):
    if userid == 0:
        stmt = "SELECT * FROM billing_log \
                    WHERE device_id = '%s' AND err = 0 ORDER BY id DESC LIMIT %d, %d" \
                    %(MySQLdb.escape_string(device_id), offset, num)
    else:
        stmt = "SELECT * FROM billing_log \
                    WHERE userid = %d AND err = 0 ORDER BY id DESC LIMIT %d, %d" \
                    %(userid, offset, num)
    logger.debug(stmt)
    conn.autocommit(True)
    conn.ping(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return []
    else:
        history = []
        for each in cur.fetchall():
            entry = BillingLog()
            entry.serial_num = each['serial_num']
            entry.userid = int(each['userid'])
            entry.device_id = each['device_id']
            entry.money = int(each['money'])
            entry.remark = each['remark']
            entry.time = str(each['insert_time'])
            history.append(entry)
        return history

