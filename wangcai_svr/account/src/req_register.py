# -*- coding: utf-8 -*-

import web
import json
import hashlib
import random
import urllib
import urllib2
import socket
import logging
import db_helper
from config import *
from data_types import *

logger = logging.getLogger()

class Handler:
    def init(self):
        params = web.input()
        self._userid = 0
        self._mac = params.mac.upper()
        self._idfa = params.idfa.upper()
        self._platform = params.platform
        self._device_id = self.calc_device_id()
        self._new_device = False
        self._ip = params.ip
        self._phone_num = ''
        self._nickname = ''
        self._invite_code = ''
        self._inviter = ''
        entry = LoginHistory()
        entry.device_id = self._device_id
        entry.platform = params.platform
        entry.version = params.version
        entry.network = params.network
        entry.ip = params.ip
        self._login_history_entry = entry
        self._banned_list = None
        self.init_banned_list()

    def init_banned_list(self):
        fp = open('../conf/bad_user.txt')
        self._banned_list = [int(line.strip()) for line in fp.readlines() if line.strip() != '']
#        logger.info('banned list size: %d' %len(self._banned_list))
#        logger.debug('banned list: %s' %str(self._banned_list))
        fp.close()

    def calc_device_id(self):
        if self._idfa == '':
            return hashlib.md5(self._mac).hexdigest()
        else:
            return hashlib.md5(self._idfa).hexdigest()

    def POST(self):
        self.init()

        #判断当前ip登陆设备数,3台以上屏蔽
#        if self._ip != '14.127.235.24':
#            device_list = db_helper.query_ip_history(self._ip)
#            if self._device_id not in device_list and len(device_list) >= 3:
#                logger.info('too many devices on ip: %s, total_device: %d' %(self._ip, len(device_list)))
#                return json.dumps({'rtn': 1})

        #判断当前ip登陆过的设备,每个类型的设备只能登陆1次
        if self._ip not in ['127.0.0.1','183.14.0.221', '121.14.98.49', '14.153.253.143', '113.92.102.40']:
            mm = db_helper.query_ip_history(self._ip)
            if self._device_id not in mm and self._platform in set(mm.values()):
                logger.info('too many devices on ip: %s, device_list: %s' %(self._ip, str(mm)))
                return json.dumps({'rtn': 1})
                

            
        #先查anonymous_device
        device = db_helper.query_anonymous_device(self._device_id)
        if device is None:
            #查不到,直接插入
            db_helper.insert_anonymous_device(self._device_id, self._mac, self._idfa, self._platform)
            self._new_device = True
            logger.debug('new device, %s' %self._device_id)
            #初次安装奖励1元
            self.recharge(self._device_id, 100, '初次安装奖励')
        elif device.flag == 0:
            #未绑定
            pass
        else:
            #已绑定,查user_device与user_info
            device = db_helper.query_user_device(self._device_id)
            #能查到
            assert device is not None

            #被屏蔽用户
            if self.is_banned(device.userid):
                logger.info('banned user!! userid:%d' %device.userid)
                return json.dumps({'rtn': 2})

            user = db_helper.query_user_info(device.userid)
            assert user is not None

            logger.debug('user: %s' %str(user.__dict__))

            self._userid = user.userid
            self._phone_num = user.phone_num
            self._invite_code = user.invite_code
            self._inviter = user.inviter_code

        #记录login_history
        self._login_history_entry.userid = self._userid
        db_helper.record_login_history(self._login_history_entry)

        resp = {
            'rtn': 0,
            'userid': self._userid,
            'device_id': self._device_id,
            'new_device': self._new_device,
            'invite_code': self._invite_code,
            'phone_num': self._phone_num,
            'inviter': self._inviter
        }

        logger.debug('resp: %s' %str(resp))

        return json.dumps(resp)

    def is_banned(self, userid):
        return userid in self._banned_list


    def recharge(self, device_id, money, remark):
        data = {
            'device_id': device_id,
            'userid': 0,
            'money': money,
            'remark': remark
        }
        url = 'http://' + BILLING_BACKEND + '/recharge'
        resp = self.make_request(url, data)
        return resp['rtn']


    def make_request(self, url, data, timeout = 3):
        logger.debug('url: %s, data: %s' %(url, json.dumps(data, ensure_ascii=False)))
        req = urllib2.Request(url, urllib.urlencode(data))
        try:
            resp = urllib2.urlopen(req, timeout = timeout).read()
            logger.debug('resp: %s' %resp)
            return json.loads(resp)
        except urllib2.HTTPError, e:
            return {'rtn': -e.code}
        except urllib2.URLError, e:
            if isinstance(e.reason, socket.timeout):
                return {'rtn': -1}
            else:
                return {'rtn': -2}


