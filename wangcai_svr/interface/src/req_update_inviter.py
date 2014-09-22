# -*- coding: utf-8 -*-

import web
import logging
import protocol
from config import *
from utils import *
from session_manager import SessionManager


logger = logging.getLogger()

class Handler:
    def POST(self):
        req = protocol.UpdateInviterReq(web.input(), web.cookies())
        resp = protocol.UpdateInviterResp()

        if not SessionManager.instance().check_session(req.session_id, req.device_id, req.userid):
            resp.res = 401
            resp.msg = '登陆态异常'
            return resp.dump_json()

        url = 'http://' + ACCOUNT_BACKEND + '/update_inviter'
        data = {
            'device_id': req.device_id,
            'userid': req.userid,
            'invite_code': req.inviter.upper()
        }

        r = http_request(url, data)
        if r['rtn'] == 2:
            resp.res = 1
            resp.msg = '不能邀请自己'
            return resp.dump_json()
        elif r['rtn'] != 0:
            resp.res = 1
            resp.msg = 'error'
            return resp.dump_json()
            
        inviter_id = int(r['inviter'])

        #在任务系统进行记录
        url = 'http://' + TASK_BACKEND + '/report_invite'
        data = {
            'userid': inviter_id,
            'invite_code': req.inviter,
            'invitee': req.userid
        }

        r = http_request(url, data)
        if r['rtn'] == 0:
            return resp.dump_json()
        else:
            resp.res = 1
            resp.msg = 'error'
            return resp.dump_json()



