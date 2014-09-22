# -*- coding: utf-8 -*-
# 话费充值订单列表

import web
import logging
import protocol
import db_helper
from data_types import *


logger = logging.getLogger()

class Handler:
    def GET(self):
        req  = protocol.OrderList_PhonePayment_Req(web.input())
        resp = protocol.OrderList_PhonePayment_Resp()

        resp.order_list = db_helper.query_order_list_phone_payment(req.offset, req.num)

        return resp.dump_json()


