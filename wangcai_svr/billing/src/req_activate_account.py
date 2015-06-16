# -*- coding: utf-8 -*-
# 激活账户

import web
import logging
import protocol
import db_helper
from data_types import *

logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.ActivateAccount_Req(web.input())
        resp = protocol.ActivateAccount_Resp()

        #userid不能为0
        if req.userid == 0:
            resp.rtn = BillingError.E_INVALID_ACCOUNT
            return resp.dump_json()

        #确认是否已存在billing_account
#        account = db_helper.query_billing_account(req.userid)
#        if account is not None:
#            logger.error('billing account already exists! userid: %d' %req.userid)
#            resp.rtn = BillingError.E_INVALID_ACCOUNT
#            return resp.dump_json()
            
        #确认是否存在anonymous_account
        account = db_helper.query_anonymous_account(req.device_id)
        if account is None:
            logger.error('account not exists!! device_id: %s' %req.device_id)
            resp.rtn = BillingError.E_NO_SUCH_ACCOUNT
            return resp.dump_json()
        elif account.flag != 0:
            logger.error('account already activated, device_id: %s' %req.device_id)
            resp.rtn = BillingError.E_INVALID_ACCOUNT
            return resp.dump_json()
            
        #进行帐号激活
        db_helper.activate_billing_account(req.userid, account)

        #查询账户余额
        account = db_helper.query_billing_account(req.userid)
        if account is None:
            logger.error('no such account!! %d' %req.userid)
            resp.rtn = BillingError.E_NO_SUCH_ACCOUNT
        else:
            resp.balance = account.money - account.freeze
            resp.income = account.income
            resp.outgo = account.outgo + account.freeze
            resp.shared_income = account.shared_income

        return resp.dump_json()
