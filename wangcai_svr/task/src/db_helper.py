# -*- coding: utf-8 -*-

#import MySQLdb
import pymysql
MySQLdb = pymysql

import logging
from config import *
from data_types import *

logger = logging.getLogger('db_helper')

conn = MySQLdb.connect(host=MYSQL_HOST, user=MYSQL_USER, passwd=MYSQL_PASSWD, db=MYSQL_DB, charset='utf8')

def query_task_base(task_id):
    stmt = "SELECT *, UNIX_TIMESTAMP(ts) AS u_ts FROM task_base WHERE id = %d" %task_id
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        res = cur.fetchone()
        task = Task()
        task.id     = int(res['id'])
        task.type   = int(res['type'])
        task.status = int(res['status'])
        task.title  = res['title']
        task.icon   = res['icon']
        task.intro  = res['intro']
        task.desc   = res['descr']
        task.steps  = res['steps'].split('|')
        task.money  = int(res['money'])
        task.timestamp = int(res['u_ts'])
        return task
        

def select_app_task():
    stmt = "SELECT *, UNIX_TIMESTAMP(ts) AS u_ts FROM task_base WHERE type = %d AND status = 0" %TaskType.T_APP
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        list = []
        for each in cur.fetchall():
            task = Task()
            task.id     = int(each['id'])
            task.type   = int(each['type'])
            task.status = int(each['status'])
            task.title  = each['title']
            task.icon   = each['icon']
            task.intro  = each['intro']
            task.desc   = each['descr']
            task.steps  = each['steps'].split('|')
            task.money  = int(each['money'])
            task.timestamp = int(each['u_ts'])
            list.append(task)
        return list


def select_builtin_task():
    stmt = "SELECT * FROM task_base WHERE type <= %d" %TaskType.T_BUILTIN
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        list = []
        for each in cur.fetchall():
            task = Task()
            task.id     = int(each['id'])
            task.type   = int(each['type'])
            task.status = int(each['status'])
            task.title  = each['title']
            task.icon   = each['icon']
            task.intro  = each['intro']
            task.desc   = each['descr']
            task.steps  = each['steps'].split('|')
            task.money  = int(each['money'])
            list.append(task)
        return list


def select_task_of_device(device_id):
    stmt = "SELECT * FROM task_of_device WHERE device_id = '%s'" %MySQLdb.escape_string(device_id)
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        list = []
        for each in cur.fetchall():
            task = TaskOfDevice()
            task.device_id = device_id
            task.task_id = int(each['task_id'])
            task.type = int(each['type'])
            task.status = int(each['status'])
            task.money = int(each['money'])
            list.append(task)
        return list

def select_task_of_user(userid):
    stmt = "SELECT * FROM task_of_user WHERE userid = %d" %userid
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return []
    else:
        list = []
        for each in cur.fetchall():
            task = TaskOfUser()
            task.userid = userid
            task.device_id = each['device_id']
            task.task_id = int(each['task_id'])
            task.type = int(each['type'])
            task.status = int(each['status'])
            task.money = int(each['money'])
            list.append(task)
        return list

def query_task_status_of_device(device_id, task_id):
    stmt = "SELECT status FROM task_of_device \
                WHERE device_id = '%s' AND task_id = %d" \
                %(MySQLdb.escape_string(device_id), task_id)
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor()
    n = cur.execute(stmt)
    if n == 0:
        return TaskStatus.S_NORMAL
    else:
        res = cur.fetchone()
        return int(res[0])


def insert_task_of_device(task):
    stmt = "INSERT IGNORE INTO task_of_device \
                SET device_id = '%s', userid = %d, task_id = %d, \
                type = %d, status = %d, money = %d" \
                % (MySQLdb.escape_string(task.device_id),
                        task.userid,
                        task.task_id,
                        task.type,
                        task.status,
                        task.money)
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    n = cur.execute(stmt)
    conn.commit()
    return n


def insert_task_of_user(task):
    stmt = "INSERT IGNORE INTO task_of_user \
                SET userid = %d, device_id = '%s', task_id = %d, \
                type = %d, status = %d, money = %d" \
                % (task.userid,
                        MySQLdb.escape_string(task.device_id),
                        task.task_id,
                        task.type,
                        task.status,
                        task.money)
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    n = cur.execute(stmt)
    conn.commit()
    return n


def insert_task_invite(task):
    stmt = "INSERT IGNORE INTO task_invite \
                SET userid = %d, invitee = %d, invite_code = '%s'" \
                %(task.userid, task.invitee, MySQLdb.escape_string(task.invite_code))
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    n = cur.execute(stmt)
    conn.commit()
    return n


def count_task_invite(userid):
    stmt = "SELECT COUNT(*) FROM task_invite WHERE userid = %d" %userid
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor()
    cur.execute(stmt)
    res = cur.fetchone()
    return int(res[0])


def insert_task_checkin(task):
    stmt = "INSERT INTO task_daily \
                SET device_id = '%s', userid = %d, date = CURDATE(), \
                    task_id = %d, type = %d, money = %d, extra = '%s'" \
                    %(MySQLdb.escape_string(task.device_id), \
                            task.userid, \
                            Task.ID_CHECKIN, \
                            TaskType.T_CHECKIN, \
                            task.money, \
                            MySQLdb.escape_string(task.extra))
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    cur.execute(stmt)
    conn.commit()
    cur.close()


def query_task_checkin_by_device_id(device_id):
    stmt = "SELECT * FROM task_daily WHERE device_id = '%s' AND date = CURDATE()" \
                % MySQLdb.escape_string(device_id)
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        cur.close()
        return None
    else:
        res = cur.fetchone()
        cur.close()
        task = TaskCheckIn()
        task.device_id = device_id
        task.userid = int(res['userid'])
        task.money = int(res['money'])
        task.extra = res['extra']
        return task

def query_task_checkin_by_userid(userid):
    stmt = "SELECT * FROM task_daily WHERE userid = %d AND date = CURDATE()" %userid
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        res = cur.fetchone()
        task = TaskCheckIn()
        task.device_id = res['device_id']
        task.userid = userid
        task.money = int(res['money'])
        task.extra = res['extra']
        return task
        

def insert_task_app(task):
    stmt = """INSERT INTO task_app
                SET appid = '%s',
                    app_name = '%s',
                    download_url = '%s',
                    redirect_url = '%s',
                    icon = '%s',
                    genre = %d,
                    filesize = %d,
                    version = '%s',
                    screenshots = '%s',
                    intro = '%s',
                    last_update = '%s',
                    score = %d,
                    download_times = %d,
                    corp_id = %d,
                    corp = '%s',
                    site = '%s',
                    contact = '%s',
                    insert_time = NOW()""" \
                    %(MySQLdb.escape_string(task.appid), \
                    MySQLdb.escape_string(task.app_name), \
                    MySQLdb.escape_string(task.download_url), \
                    MySQLdb.escape_string(task.redirect_url), \
                    MySQLdb.escape_string(task.icon), \
                    task.genre, \
                    task.filesize, \
                    MySQLdb.escape_string(task.version), \
                    MySQLdb.escape_string(task.screenshots), \
                    MySQLdb.escape_string(task.intro), \
                    MySQLdb.escape_string(task.intro), \
                    '2013-12-30', \
                    task.score, \
                    task.download_times, \
                    task.corp_id, \
                    MySQLdb.escape_string(task.corp), \
                    MySQLdb.escape_string(task.site), \
                    MySQLdb.escape_string(task.contact))

    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    cur.execute()
    conn.commit()


def query_task_app(task_id):
    stmt = "SELECT * FROM task_app WHERE id = %d" %task_id
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        res = cur.fetchone()
        task = TaskApp()
        task.id         = task_id
        task.appid      = res['appid']
        task.app_name   = res['app_name']
        task.download_url = res['download_url']
        task.redirect_url = res['redirect_url']
        task.icon       = res['icon']
        task.genre      = int(res['genre'])
        task.filesize   = int(res['filesize'])
        task.version    = res['version']
        task.screenshots = res['screenshots']
        task.intro      = res['intro']
        task.last_update = res['last_update']
        task.score      = int(res['score'])
        task.download_times = int(res['download_times'])
        task.corp_id    = int(res['corp_id'])
        task.corp       = res['corp']
        task.site       = res['site']
        task.contact    = res['contact']
        task.money      = int(res['money'])
        return task


def query_task_app_by_appid(appid):
    stmt = "SELECT * FROM task_app WHERE appid = '%s'" %MySQLdb.escape_string(appid)
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor(MySQLdb.cursors.DictCursor)
    n = cur.execute(stmt)
    if n == 0:
        return None
    else:
        res = cur.fetchone()
        task = TaskApp()
        task.id         = int(res['id'])
        task.appid      = appid
        task.app_name   = res['app_name']
        task.download_url = res['download_url']
        task.redirect_url = res['redirect_url']
        task.icon       = res['icon']
        task.genre      = int(res['genre'])
        task.filesize   = int(res['filesize'])
        task.version    = res['version']
        task.screenshots = res['screenshots']
        task.intro      = res['intro']
        task.last_update = res['last_update']
        task.score      = int(res['score'])
        task.download_times = int(res['download_times'])
        task.corp_id    = int(res['corp_id'])
        task.corp       = res['corp']
        task.site       = res['site']
        task.contact    = res['contact']
        task.money      = int(res['money'])
        return task


def insert_task_app_download(device_id, userid, appid):
    stmt = "REPLACE INTO task_app_download \
                SET device_id = '%s', userid = %d, appid = '%s'" \
                % (MySQLdb.escape_string(device_id), 
                        userid, 
                        MySQLdb.escape_string(appid))
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    cur.execute(stmt)
    conn.commit()


def query_task_app_download(device_id, appid):
    stmt = "SELECT * FROM task_app_download WHERE device_id = '%s' AND appid = '%s'" \
                % (MySQLdb.escape_string(device_id), MySQLdb.escape_string(appid))
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor()
    n = cur.execute(stmt)
    return n != 0
    

def query_offer_wall_point(device_id, type):
    stmt = "SELECT point FROM offer_wall_point WHERE device_id = '%s' AND type = %d" \
                % (MySQLdb.escape_string(device_id), type)
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(True)
    cur = conn.cursor()
    n = cur.execute(stmt)
    if n == 0:
        return 0
    else:
        res = cur.fetchone()
        return int(res[0])

def insert_offer_wall_point(device_id, type, point):
    stmt = "INSERT INTO offer_wall_point \
                SET device_id = '%s', type = %d, point = %d, create_time = NOW()" \
                % (MySQLdb.escape_string(device_id), type, point)
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    cur.execute(stmt)
    conn.commit()

def update_offer_wall_point(device_id, type, point):
    stmt = "UPDATE offer_wall_point SET point = %d WHERE device_id = '%s' AND type = %d" \
                % (point, MySQLdb.escape_string(device_id), type)
    logger.debug(stmt)
    conn.ping(True)
    cur = conn.cursor()
    cur.execute(stmt)
    conn.commit()


def update_offerwall_point(device_id, type, increment, unique_task_id):
    stmt_log = "INSERT INTO offer_wall_point_log \
                   SET unique_task_id = '%s', device_id = '%s', type = %d, point = %d, create_time = NOW()" \
                   % (unique_task_id, MySQLdb.escape_string(device_id), type, increment)
    stmt = "SELECT point FROM offer_wall_point WHERE device_id = '%s' AND type = %d" \
                % (MySQLdb.escape_string(device_id), type)
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(False)
    cur = conn.cursor()
    n = cur.execute(stmt)
    if n == 0:
        logger.debug(stmt_log)
        cur.execute(stmt_log)
        stmt = "INSERT INTO offer_wall_point \
                    SET device_id = '%s', type = %d, point = %d, create_time = NOW()" \
                    % (MySQLdb.escape_string(device_id), type, increment)
        logger.debug(stmt)
        cur.execute(stmt)
        conn.commit()
        return increment
    else:
        res = cur.fetchone()
        logger.debug(stmt_log)
        cur.execute(stmt_log)
        stmt = "UPDATE offer_wall_point SET point = %d WHERE device_id = '%s' AND type = %d" \
                    % (increment, MySQLdb.escape_string(device_id), type)
        logger.debug(stmt)
        cur.execute(stmt)
        conn.commit()
        return int(res[0]) + increment

def check_offerwall_point_has_reported(unique_task_id):
    if len(unique_task_id) <= 0:
        return 1
    stmt = "SELECT * FROM offer_wall_point_log WHERE unique_task_id = '%s'" \
                % (MySQLdb.escape_string(unique_task_id))
    logger.debug(stmt)
    conn.ping(True)
    conn.autocommit(False)
    cur = conn.cursor()
    n = cur.execute(stmt)
    if n == 0:
        return 0
    else:
        return 1


