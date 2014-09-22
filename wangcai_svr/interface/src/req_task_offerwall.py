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
        req  = protocol.ReportOfferWallPointReq(web.input(), web.cookies())
        resp = protocol.ReportOfferWallPointResp()

        logger.debug('domob point: %d, youmi point: %d, userid:%d, device_id:%s' \
                    %(req.domob_point, req.youmi_point, req.userid, req.device_id))

        if not SessionManager.instance().check_session(req.session_id, req.device_id, req.userid):
            resp.res = 401
            resp.msg = '登陆态异常'
            return resp.dump_json()

        if req.userid != 0:
            inviter = self.query_inviter(req.userid)
        else:
            inviter = 0

        if req.domob_point > 0:
            income = self.report_domob_point(req.userid, req.device_id, inviter, req.domob_point)
            if income < 0:
                logger.error('report_domob_point failed!! rtn:%d' %income)
                resp.res = -income
                resp.msg = 'report_domob_point failed!!'
                return resp.dump_json()
            resp.income += income

        if req.youmi_point > 0:
            income = self.report_youmi_point(req.userid, req.device_id, inviter, req.youmi_point)
            if income < 0:
                logger.error('report_youmi_point failed!! rtn:%d' %income)
                resp.res = -income
                resp.msg = 'report_youmi_point failed!!'
                return resp.dump_json()
            resp.income += income

        return resp.dump_json()


    def query_inviter(self, userid):
        url = 'http://' + ACCOUNT_BACKEND + '/inviter?userid=' + str(userid)
        r = http_request(url)
        if r['rtn'] == 0:
            return r['inviter']
        else:
            return 0

    def report_domob_point(self, userid, device_id, inviter, point):
        params = {
            'device_id': device_id,
            'userid': userid,
            'type': 0,
            'increment': point,
            'inviter': inviter
        }
        url = 'http://' + TASK_BACKEND + '/report_task_offerwall'
        r = http_request(url, params)
        if r['rtn'] == 0:
            return r['income']
        else:
            return -r['rtn']


    def report_youmi_point(self, userid, device_id, inviter, point):
        params = {
            'device_id': device_id,
            'userid': userid,
            'type': 1,
            'increment': point,
            'inviter': inviter
        }
        url = 'http://' + TASK_BACKEND + '/report_task_offerwall'
        r = http_request(url, params)
        if r['rtn'] == 0:
            return r['income']
        else:
            logger.error('report_youmi_point failed!! rtn:%d' %r['rtn'])
            return -r['rtn']

