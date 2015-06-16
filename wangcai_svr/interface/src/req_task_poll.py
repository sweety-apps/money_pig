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
    def GET(self):
        req  = protocol.ReportPollReq(web.input(), web.cookies())
        resp = protocol.ReportPollResp()

        if not SessionManager.instance().check_session(req.session_id, req.device_id, req.userid):
            resp.res = 401
            resp.msg = '登陆态异常'
            return resp.dump_json()

        data = {
            'userid': req.userid,
            'device_id': req.device_id
        }

        url = 'http://' + BILLING_BACKEND + '/query_balance?' + urllib.urlencode(data)

        logger.debug('[POLL] billing request, url = %s' %(url))

        r = http_request(url)

        if r['rtn'] == 0:
            resp.res = 0
            resp.msg = '成功'
            resp.offerwall_income = r['offerwall_income']
        else:
            resp.res = 589
            resp.msg = '查询余额错误'
            return resp.dump_json()

        return resp.dump_json()

