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

        is_task_finished = db_helper.check_offerwall_point_has_reported(req.unique_task_id)
        if is_task_finished:
            logger.error("[OFFERWALL CALLBACK] task has finished, unique_task_id = %s",req.unique_task_id)
            resp.rtn = -1
            return resp.dump_json()

        total = db_helper.update_offerwall_point(req.device_id, req.type, req.increment, req.unique_task_id)
        
        income = req.increment * 10
        BillingClient.instance().recharge(req.device_id, req.userid, income, req.remark, income)

        if req.inviter != 0:
            BillingClient.instance().share_income(req.inviter, req.userid, int(income/10.0))

        resp.income = income
        return resp.dump_json()


