# -*- coding: utf-8 -*-

import json
import urllib
import urllib2
import logging
from config import *

logger = logging.getLogger('order_client')

class OrderType:
    T_ALIPAY = 1
    T_PHONE_PAY = 2

class OrderStatus:
    S_PENDING = 0
    S_CONFIRMED = 1
    S_OPERATED = 2

class Order:
    def __init__(self):
        self.userid = 0
        self.device_id = ''
        self.serial_num = ''
        self.type = 0
        self.status = 0
        self.money = 0
        self.create_time = ''
        self.extra = ''

class OrderClient:

    s_instance = None

    @classmethod
    def instance(cls):
        if cls.s_instance is None:
            cls.s_instance = cls()
        return cls.s_instance

    def __init__(self):
        pass

    def order_list(self, offset, num):
        data = {'offset':offset, 'num':num}
        url = ORDER_BACKEND + '/order_list'
        resp = self.make_request(url, 'GET', data)
        if resp['rtn'] != 0:
            return (resp['rtn'], None)
        else:
            return (0, resp['order_list'])
        

    def order_detail(self, userid, order_id):
        data = {'userid': userid, 'order_id': order_id}
        url = ORDER_BACKEND + '/order_detail'
        resp = self.make_request(url, 'GET', data)
        if resp['rtn'] != 0:
            return (resp['rtn'], None)
        else:
            order = Order()
            order.userid = resp['userid']
            order.device_id = resp['device_id']
            order.serial_num = resp['serial_num']
            order.type = resp['type']
            order.status = resp['status']
            order.money = resp['money']
            order.create_time = resp['create_time']
            order.extra = resp['extra']
            return (0, order)


    def confirm_order_alipay(self, userid, order_id):
        data = {'userid': userid, 'serial_num': order_id}
        url = ORDER_BACKEND + '/confirm_alipay_transfer'
        resp = self.make_request(url, 'POST', data)
        return resp['rtn']

    def confirm_order_phone_charge(self, userid, order_id):
        data = {'userid': userid, 'serial_num': order_id}
        url = ORDER_BACKEND + '/confirm_phone_payment'
        resp = self.make_request(url, 'POST', data)
        return resp['rtn']


    def make_request(self, url, method, data, timeout = 3):
        logger.debug('url: %s, data: %s' %(url, json.dumps(data, ensure_ascii=False)))
        if method.upper() == 'POST':
            req = urllib2.Request(url, urllib.urlencode(data))
        else:
            req = urllib2.Request(url + '?' + urllib.urlencode(data))

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

