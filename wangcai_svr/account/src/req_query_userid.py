# -*- coding: utf-8 -*-

import web
import json
import hashlib
import logging
import db_helper


logger = logging.getLogger()

class Handler:
    def init(self):
        params = web.input()
        self._mac = params.mac.upper()
        self._idfa = params.idfa.upper()

    def GET(self):
        self.init()
        device_id = self.calc_device_id()
        userid = self.query_userid(device_id)
        return json.dumps({'rtn': 0, 'userid': userid, 'device_id': device_id})

    def calc_device_id(self):
        if self._idfa == '':
            return hashlib.md5(self._mac).hexdigest()
        else:
            return hashlib.md5(self._idfa).hexdigest()

    def query_userid(self, device_id):
        #先查anonymous_device
        device = db_helper.query_anonymous_device(device_id)
        if device is None:
            return -1
        elif device.flag == 0:
            return 0
        else:
            #已绑定,查user_device
            device = db_helper.query_user_device(device_id)
            assert device is not None
            return device.userid



