# -*- coding: utf-8 -*-
# 查询日志

import web
import logging
import protocol
import db_helper
from data_types import *

logger = logging.getLogger()

class Handler:
    def GET(self):
        req  = protocol.QueryHistory_Req(web.input())
        resp = protocol.QueryHistory_Resp()

        resp.history = db_helper.query_billing_log(req.device_id, req.userid, req.offset, req.num)

        for each in resp.history:
            if each.remark.startswith('体验应用赚取'):
                each.remark = '体验应用'
            elif each.remark.startswith('抽奖赢得'):
                each.remark = '签到抽奖'

        return resp.dump_json()
        
