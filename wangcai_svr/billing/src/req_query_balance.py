# -*- coding: utf-8 -*-
# 查询余额

import web
import logging
import protocol
import db_helper
from data_types import *

logger = logging.getLogger()

class Handler:
    def GET(self):
        req  = protocol.QueryBalance_Req(web.input())
        resp = protocol.QueryBalance_Resp()

        if req.userid == 0:
            account = db_helper.query_anonymous_account(req.device_id)
            if account is None:
                logger.info('no such account!! %s' %req.device_id)
                resp.rtn = BillingError.E_NO_SUCH_ACCOUNT
            else:
                resp.balance = account.money
                resp.income = account.money
                resp.outgo = 0
                resp.shared_income = 0
        else:
            account = db_helper.query_billing_account(req.userid)
            if account is None:
                logger.info('no such account!! %d' %req.userid)
                resp.rtn = BillingError.E_NO_SUCH_ACCOUNT
            else:
                resp.balance = account.money - account.freeze
                resp.income = account.income
                resp.outgo = account.outgo + account.freeze
                resp.shared_income = account.shared_income
            
        return resp.dump_json()


