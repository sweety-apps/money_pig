# -*- coding: utf-8 -*-

import web
import json
import logging
import protocol
from config import *
from utils import *

logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.ReportDomobPointReq(web.input(), web.cookies())
        resp = protocol.ReportDomobPointResp()

        logger.debug('domob point: %d, userid:%d, device_id:%s' %(req.point, req.userid, req.device_id))

        inviter = 0
        if req.userid != 0:
            inviter = self.query_inviter(req.userid)

        params = {
            'device_id': req.device_id,
            'userid': req.userid,
            'point': req.point,
            'inviter': inviter
        }

        if req.type == 0:
            url = 'http://' + TASK_BACKEND + '/report_domob_point'
        elif req.type == 1:
            url = 'http://' + TASK_BACKEND + '/report_youmi_point'
        else:
            logger.error('unexpected type: %d' %req.type)
            resp.res = 1
            resp.msg = '参数错误'
            return resp.dump_json()

        r = http_request(url, params)
        if r['rtn'] == 0:
            resp.increment = r['increment']
        else:
            resp.res = r['rtn']

        return resp.dump_json()

    def query_inviter(self, userid):
        url = 'http://' + ACCOUNT_BACKEND + '/inviter?userid=' + str(userid)
        r = http_request(url)
        if r['rtn'] == 0:
            return r['inviter']
        else:
            return 0
