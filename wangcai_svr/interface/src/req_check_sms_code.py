# -*- coding: utf-8 -*-

import web
import json
import logging
import urllib
from config import *
from utils import *
from sms_center import *

class Handler:
    def POST(self):
        logger = logging.getLogger('root')
        params = web.input()
        token = params.token
        sms_code = params.sms_code

        sms = SMSCenter.instance()

        ret = sms.check_sms(token, sms_code)
        if ret is None:
            logger.info('check sms code failed!! token:%s, code:%s' %(token, sms_code))
            resp = {'res': 1, 'msg': 'error'}
        else:
            action, data = ret
            #修改状态
            sms.update_status(token, SMSStatus.SMS_CONFIRMED)
            
            resp = self.apply_action(action, data)

        return json.dumps(resp)

    
    def apply_action(self, action, data):
        if action == SMSAction.BIND_PHONE:
            return self.apply_bind_phone(json.loads(data))
        elif action == SMSAction.TRANSFER_MONEY:
            return self.apply_transfer_money(json.loads(data))
        else:
            return {'res': 1, 'msg': 'error'}


    def apply_bind_phone(self, data):
        url = 'http://' + ACCOUNT_BACKEND + '/bind_phone'
        r = http_request(url, data)
        if r.has_key('rtn') and r['rtn'] == 0:
            return {
                'res': 0,
                'msg': '',
                'userid': int(r['userid'])
            }
        else:
            return {'res': 1, 'msg': 'error'}


    def apply_transfer_money(self, data):
        pass
            
