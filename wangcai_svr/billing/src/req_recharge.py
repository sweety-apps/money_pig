# -*- coding: utf-8 -*-
# 向给定账户充值

import web
import logging
import protocol
import db_helper


logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.Recharge_Req(web.input())
        resp = protocol.Recharge_Resp()

        if req.userid == 0:
            resp.rtn = db_helper.recharge_anonymous_account(req.device_id, req.money, req.remark)
        else:
            resp.rtn = db_helper.recharge_billing_account(req.userid, req.device_id, req.money, req.remark)

        return resp.dump_json()
            
            
        
