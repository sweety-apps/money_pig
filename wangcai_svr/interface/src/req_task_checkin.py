# -*- coding: utf-8 -*-

import web
import json
import logging
import protocol
from config import *
from utils import *
from session_manager import SessionManager

logger = logging.getLogger()

class AwardType:
    T_NONE = 0
    T_1MAO = 1
    T_5MAO = 2
    T_3YUAN = 3
    T_8YUAN = 5


class Handler:
    def POST(self):
        req  = protocol.CheckInReq(web.input(), web.cookies())
        resp = protocol.CheckInResp()

        if not SessionManager.instance().check_session(req.session_id, req.device_id, req.userid):
            resp.res = 401
            resp.msg = '登陆态异常'
            return resp.dump_json()

        data = {
            'userid': req.userid,
            'device_id': req.device_id
        }

        url = 'http://' + TASK_BACKEND + '/check-in'

        r = http_request(url, data)
        if r['rtn'] == 0:
            resp.award = r['award']
        elif r['rtn'] == 1:
            resp.res = 1
            resp.msg = '您今天已抽奖，明天再来试试运气吧！'
        else:
            resp.res = 1
            resp.msg = 'error'
        
        return resp.dump_json()

