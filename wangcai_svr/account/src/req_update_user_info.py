# -*- coding: utf-8 -*-

import web
import json
import logging
import db_helper
from data_types import *

class Handler:
    def init(self):
        params = web.input()
        self._userid = int(params.userid)
        self._device_id = params.device_id
        self._user_info = UserInfo()
        self._user_info.sex = int(params.sex)
        self._user_info.age = int(params.age)
        self._user_info.interest = params.interest

    def POST(self):
        self.init()

        #如果未绑定手机,修改anonymous_device内的user_info字段,否则直接修改user_info表
        if self._userid == 0:
            db_helper.update_anonymous_user_info(self._device_id, self._user_info)
        else:
            db_helper.update_user_info(self._userid, self._user_info)
            
        return json.dumps({'rtn': 0})

