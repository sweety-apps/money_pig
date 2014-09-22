# -*- coding: utf-8 -*-

import web
import logging
import protocol
import db_helper
from data_types import *
from billing_client import BillingClient

logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.ReportOfferWall_Req(web.input())
        resp = protocol.ReportOfferWall_Resp()

        total = db_helper.update_offerwall_point(req.device_id, req.type, req.increment)
        
        income = req.increment * 10
        BillingClient.instance().recharge(req.device_id, req.userid, income, '体验应用赚取%.1f元' %(income/100.0))

        if req.inviter != 0:
            BillingClient.instance().share_income(req.inviter, req.userid, int(income/10.0))

        resp.income = income
        return resp.dump_json()


