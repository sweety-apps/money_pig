# -*- coding: utf-8 -*-

import web
import json
import hashlib
import urllib
import logging

YOUMI_SECRET = '52e9439d8a88a513'

logger = logging.getLogger()

class Handler:
    def __init__(self):
        self.order_id = ''
        self.appid = ''
        self.ad = ''
        self.adid = 0
        self.userid = ''
        self.device_id = ''
        self.channel = 0
        self.price = 0.0
        self.points = 0
        self.order_time = 0
        self.sig = ''
        self.sign = ''

    def parse_params(self):
        params = web.input()
        self.order_id = params.get('order', '')
        self.appid = params.get('app', '')
        self.ad = params.get('ad', '')
        self.adid = int(params.get('adid', 0))
        self.userid = params.get('user', '')
        self.device_id = params.get('device', '')
        self.channel = int(params.get('chn', 0))
        self.price = params.get('price', '')
        self.points = int(params.get('points', 0))
        self.order_time = int(params.get('time', 0))
        self.sig = params.get('sig', '')
        self.sign = params.get('sign', '')

        sign = self.calc_sign()

        logger.debug('params: %s' %str(self.__dict__))
        logger.debug('sign: %s' %sign)
        return True

    def calc_sign(self):
        '''sign = md5("ad={$ad}adid={$adid}app={$app}chn={$chn}device={$device}order={$order}points={$points}price={$price}sig={$sig}time={$time}user={$user}{$dev_server_secret}");'''
        m = {
            'ad': self.ad,
            'adid': self.adid,
            'app': self.appid,
            'chn': self.channel,
            'device': self.device_id,
            'order': self.order_id,
            'points': self.points,
            'price': self.price,
            'sig': self.sig,
            'time': self.order_time,
            'user': self.userid
        }
        s = ''.join(['%s=%s' %(k, str(v)) for k, v in sorted(m.items())])
        logger.debug('sign: %s' %s)
        return hashlib.md5(s + YOUMI_SECRET).hexdigest()

    def GET(self):
        if not self.parse_params():
            return 'OK'
        else:
            return 'OK'

