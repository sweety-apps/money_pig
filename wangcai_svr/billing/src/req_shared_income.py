# -*- coding: utf-8 -*-
# 获得分成收入

import web
import logging
import protocol
import db_helper
from data_types import *

logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.SharedIncome_Req(web.input())
        resp = protocol.SharedIncome_Resp()

        #userid不能为0
        if req.userid == 0:
            resp.rtn = BillingError.E_INVALID_ACCOUNT
            return resp.dump_json()

        #确认是否已存在billing_account
        account = db_helper.query_billing_account(req.userid)
        if account is None:
            logger.error('billing account not exists! userid: %d' %req.userid)
            resp.rtn = BillingError.E_NO_SUCH_ACCOUNT
            return resp.dump_json()
        
        #充帐
        db_helper.add_shared_income(req.userid, req.money)
        return resp.dump_json()
