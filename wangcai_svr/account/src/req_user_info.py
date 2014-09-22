# -*- coding: utf-8 -*-

import web
import json
import logging
import db_helper

class Handler:
    def init(self):
        params = web.input()
        self._userid = int(params.userid)
        self._device_id = params.device_id


    def GET(self):
        logger = logging.getLogger('root')
        self.init()

        #未绑定手机,直接查anonymous_device
        if self._userid == 0:
            anony = db_helper.query_anonymous_device(self._device_id)
            if anony is None:
                logger.error('query_anonymous_device failed!! device_id:%s' %self._device_id)
            else:
                resp = {
                    'rtn': 0,
                    'userid': 0,
                    'phone_num': '',
                    'sex': anony.sex,
                    'age': anony.age,
                    'interest': anony.interest,
                    'invite_code': '',
                    'inviter': '',
                    'activate_time': ''
                }
        else:
            user = db_helper.query_user_info(self._userid)
            if user is None:
                logger.debug('query_user_info failed!! userid:%d' %self._userid)
            else:
                resp = {
                    'rtn': 0,
                    'userid': self._userid,
                    'phone_num': user.phone_num,
                    'sex': user.sex,
                    'age': user.age,
                    'interest': user.interest,
                    'invite_code': user.invite_code,
                    'inviter': user.inviter_code,
                    'activate_time': user.create_time
                }
        return json.dumps(resp)


