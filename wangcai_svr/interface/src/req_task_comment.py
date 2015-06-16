# -*- coding: utf-8 -*-

import web
import json
import logging
import protocol
from config import *
from utils import *
from session_manager import SessionManager

logger = logging.getLogger()

class Handler:
    def POST(self):
        req = protocol.ReportCommentReq(web.input(), web.cookies())
        resp = protocol.ReportCommentResp()

        if not SessionManager.instance().check_session(req.session_id, req.device_id, req.userid):
            resp.res = 401
            resp.msg = '登陆态异常'
            return resp.dump_json()
            
        url = 'http://' + TASK_BACKEND + '/report_comment'
        data = {
            'userid': req.userid,
            'device_id': req.device_id
        }

        r = http_request(url, data)
        if r['rtn'] == 0:
            resp.income = r.get('income', 0)
        else:
            resp.res = 1
            resp.msg = 'error'

        return resp.dump_json()

