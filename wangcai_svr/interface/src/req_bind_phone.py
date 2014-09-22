# -*- coding: utf-8 -*-

import web
import json
import logging
from config import *
from utils import *
from sms_center import *
from session_manager import SessionManager

class Handler:
    def POST(self):
        logger = logging.getLogger('root')
        params = web.input()
        session_id = params.session_id
        device_id = params.device_id
        userid = int(params.userid)
        phone_num = params.phone

        if not SessionManager.instance().check_session(session_id, device_id, userid):
            resp = {'res':401, 'msg':'登陆态异常'}
            return json.dumps(resp, ensure_ascii=False)

        data = {
            'userid': int(params.userid),
            'device_id': params.device_id,
            'phone': params.phone
        }

        logger.debug('userid: ' + params.userid )
        logger.debug('device_id: ' + params.device_id)
        logger.debug('phone: ' + params.phone)

        sms = SMSCenter.instance()

        #创建短信任务,写数据库
        token, code = sms.create_sms_task(phone_num, SMSAction.BIND_PHONE, json.dumps(data))
        
        #发送短信
        ret = sms.send_sms_code(phone_num, code)
        if ret:
            sms.update_status(token, SMSStatus.SMS_SUCC)
            resp = {'res': 0, 'msg': '', 'token': token}
        else:
            sms.update_status(token, SMSStatus.SMS_FAIL)
            resp = {'res': 1, 'msg': 'error'}

        return json.dumps(resp)

