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
        req  = protocol.ReportDomobPoint_Req(web.input())
        resp = protocol.ReportDomobPoint_Resp()

        point = db_helper.query_offer_wall_point(req.device_id, OfferWallType.T_DOMOB)
        if point > req.point:
            logger.error('invalid domob point, %d => %d' %(point, req.point))
            resp.rtn = 1
        elif point < req.point:
            if point == 0:
                db_helper.insert_offer_wall_point(req.device_id, OfferWallTypes.T_DOMOB, req.point)
            else:
                db_helper.update_offer_wall_point(req.device_id, OfferWallTypes.T_DOMOB, req.point)

            inc = (req.point - point)*10
            BillingClient.instance().recharge(req.device_id, req.userid, inc, '体验应用赚取%.1f元' %(inc/100.0))
            resp.increment = inc

            if req.inviter != 0:
                BillingClient.instance().share_income(req.inviter, req.userid, int(inc/10.0))

        return resp.dump_json()


