# -*- coding: utf-8 -*-

#import MySQLdb
import pymysql
MySQLdb = pymysql

import logging
import utils
from config import *
from data_types import *



logger = logging.getLogger('db_helper')

conn = MySQLdb.connect(host=MYSQL_HOST, user=MYSQL_USER, passwd=MYSQL_PASSWD, db=MYSQL_DB, charset='utf8')

#def db_exec_select(stmt):
#    conn.ping(True)
#    cur = conn.cursor(MySQLdb.cursors.DictCursor)
#    cur.execute(stmt)

def query_user_info(userid):
    stmt = "SELECT * FROM user_info WHERE id = %d" %userid
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        res = cur.fetchone()
        logger.debug('phone_num: ' + res['phone_num'])
        user = UserInfo()
        user.userid = userid
        user.phone_num = res['phone_num']
        user.sex = int(res['sex'])
        user.age = int(res['age'])
        user.interest = res['interest']
        user.invite_code = res['invite_code']
        user.inviter_id = int(res['inviter_id'])
        user.inviter_code = res['inviter_code']
        user.create_time = str(res['create_time'])
        return user


def query_userid_by_invite_code(invite_code):
    stmt = "SELECT * FROM user_info WHERE invite_code = '%s'" \
                %(MySQLdb.escape_string(invite_code))
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        res = cur.fetchone()
        logger.debug('invite_code: %s, userid: %d' %(invite_code, int(res['id'])))
        return int(res['id'])
        
def count_user_device(userid):
    stmt = "SELECT COUNT(*) FROM user_device WHERE userid = %d" %userid
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor()
    cur.execute(stmt)
    res = cur.fetchone()
    return int(res[0])


def query_user_device(device_id):
    stmt = "SELECT * FROM user_device WHERE device_id = '%s'" \
                %(MySQLdb.escape_string(device_id))
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        res = cur.fetchone()
        device = UserDevice()
        device.device_id = device_id
        device.mac = res['mac']
        device.idfa = res['idfa']
        device.platform = res['platform']
        device.userid = int(res['userid'])
#        device.status = int(res['status'])
        return device


def query_anonymous_device(device_id):
    stmt = "SELECT * FROM anonymous_device WHERE device_id = '%s'" %device_id
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        res = cur.fetchone()
        device = AnonymousDevice()
        device.device_id = device_id
        device.mac = res['mac']
        device.idfa = res['idfa']
        device.platform = res['platform']
        device.flag = int(res['flag'])
        device.sex = int(res['sex'])
        device.age = int(res['age'])
        device.interest = res['interest']
        device.activate_time = str(res['activate_time'])
        return device


def insert_anonymous_device(device_id, mac, idfa, platform):
    stmt = "INSERT INTO anonymous_device \
                SET device_id = '%s', mac = '%s', idfa = '%s', platform = '%s', interest = '', activate_time = NOW()" \
                % (MySQLdb.escape_string(device_id), 
                        MySQLdb.escape_string(mac), 
                        MySQLdb.escape_string(idfa), 
                        MySQLdb.escape_string(platform)) 
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor()
    logger.debug(stmt)
    cur.execute(stmt)
    conn.commit()


#def add_user(phone_num):
#    stmt = "INSERT IGNORE INTO user_info SET phone_num = '%s', create_time = NOW()" % MySQLdb.escape_string(phone_num)
#    logger.debug(stmt)
#    conn.ping(True)
#    cur = conn.cursor()
#    cur.execute(stmt)
#    userid = conn.insert_id()
#    conn.commit()
#    return userid


def insert_user_info(phone_num, sex, age, interest, invite_code):
    stmt = "INSERT IGNORE INTO user_info \
                SET phone_num = '%s', sex = %d, age = %d, interest = '%s', invite_code = '%s', create_time = NOW()" \
                % (MySQLdb.escape_string(phone_num), sex, age, 
                        MySQLdb.escape_string(interest),
                        MySQLdb.escape_string(invite_code))
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(False)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n != 0:
        user = UserInfo()
        user.userid = conn.insert_id()
        user.phone_num = phone_num
        user.sex = sex
        user.age = age
        user.interest = interest
        user.invite_code = invite_code
    else:
        #phone_num冲突
        stmt = "SELECT * FROM user_info WHERE phone_num = '%s'" %MySQLdb.escape_string(phone_num)
        n = cur.execute(stmt)
        assert n != 0
        res = cur.fetchone()
        user = UserInfo()
        user.userid = int(res['id'])
        user.phone_num = phone_num
        user.sex = int(res['sex'])
        user.age = int(res['age'])
        user.interest = res['interest']
        user.invite_code = res['invite_code']
        user.inviter_id = int(res['inviter_id'])
        user.inviter_code = res['inviter_code']
    conn.commit()
    return user


def insert_user_device(userid, device_id, idfa, mac, platform):
    stmt = "INSERT INTO user_device \
                SET userid = %d, device_id = '%s', mac = '%s', idfa = '%s', platform = '%s', activate_time = NOW()" \
                % (userid, MySQLdb.escape_string(device_id), 
                        MySQLdb.escape_string(mac), 
                        MySQLdb.escape_string(idfa), 
                        MySQLdb.escape_string(platform))
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor()
    cur.execute(stmt)
    conn.commit()


def update_phone_num(userid, phone_num):
    stmt = "UPDATE user_info SET phone_num = '%s' WHERE id = %d" \
                % (MySQLdb.escape_string(phone_num), userid)
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor()
    cur.execute(stmt)
    conn.commit()


def update_user_info(userid, user_info):
    stmt = "UPDATE user_info \
                SET sex = %d, age = %d, interest = '%s' WHERE id = %d" \
                % (user_info.sex,
                        user_info.age, 
                        MySQLdb.escape_string(user_info.interest), 
                        userid)
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor()
    cur.execute(stmt)
    conn.commit()


def update_inviter(userid, inviter_id, inviter_code):
    stmt = "UPDATE user_info \
                SET inviter_id = %d, inviter_code = '%s' WHERE id = %d" \
                % (inviter_id, MySQLdb.escape_string(inviter_code), userid)
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor()
    cur.execute(stmt)
    conn.commit()


def update_anonymous_device_flag(device_id, flag):
    stmt = "UPDATE anonymous_device SET flag = %d WHERE device_id = '%s'" \
                % (flag, MySQLdb.escape_string(device_id))
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor()
    cur.execute(stmt)
    conn.commit()


def update_anonymous_user_info(device_id, user_info):
    stmt = "UPDATE anonymous_device \
                SET sex = '%d', age = '%d', interest = '%s' \
                WHERE device_id = '%s'" \
                % (user_info.sex, user_info.age, 
                        MySQLdb.escape_string(user_info.interest),
                        device_id)
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor()
    cur.execute(stmt)
    conn.commit()


def record_login_history(entry):
    stmt = "INSERT INTO login_history \
                SET userid = %d, \
                device_id = '%s', \
                platform = '%s', \
                version = '%s', \
                ip = '%s', \
                network = '%s'" \
                % (entry.userid,
                        MySQLdb.escape_string(entry.device_id),
                        MySQLdb.escape_string(entry.platform),
                        MySQLdb.escape_string(entry.version),
                        entry.ip,
                        MySQLdb.escape_string(entry.network))
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor()
    cur.execute(stmt)
    conn.commit()


def query_ip_history(ip):
    stmt = "SELECT device_id, platform FROM login_history WHERE ip = '%s'" %ip
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor()
    n = cur.execute(stmt)
    if n == 0:
        return {}
    else:
        m = {}
        for each in cur.fetchall():
            m[each[0]] = each[1]
        return m
            


                

