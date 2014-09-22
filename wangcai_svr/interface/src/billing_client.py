# -*- coding: utf-8 -*-

import json
import urllib
import urllib2
import logging
from config import *

logger = logging.getLogger('billing_client')

class BillingClient:

    s_instance = None

    @classmethod
    def instance(cls):
        if cls.s_instance is None:
            cls.s_instance = cls()
        return cls.s_instance

    def __init__(self):
        pass

    def recharge(self, device_id, userid, money, remark):
        data = {
            'device_id': device_id,
            'userid': userid,
            'money': money,
            'remark': remark
        }
        url = 'http://' + BILLING_BACKEND + '/recharge'
        resp = self.make_request(url, data)
        return resp['rtn']

    def freeze(self, userid, device_id, money, remark):
        data = {
            'userid': userid,
            'device_id': device_id,
            'money': money,
            'remark': remark
        }
        url = 'http://' + BILLING_BACKEND + '/freeze'
        resp = self.make_request(url, data)
        return resp['rtn'], resp['serial_num']

    def rollback(self, userid, device_id, serial_num):
        data = {
            'userid': userid,
            'device_id': device_id,
            'serial_num': serial_num
        }
        url = 'http://' + BILLING_BACKEND + '/rollback'
        resp = self.make_request(url, data)
        return resp['rtn']

    def commit(self, userid, device_id, serial_num):
        data = {
            'userid': userid,
            'device_id': device_id,
            'serial_num': serial_num
        }
        url = 'http://' + BILLING_BACKEND + '/commit'
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


