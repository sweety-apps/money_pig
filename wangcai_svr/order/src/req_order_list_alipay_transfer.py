# -*- coding: utf-8 -*-
# 支付宝转账订单列表

import web
import logging
import protocol
import db_helper
from data_types import *


logger = logging.getLogger()

class Handler:
    def GET(self):
        req  = protocol.OrderList_AlipayTransfer_Req(web.input())
        resp = protocol.OrderList_AlipayTransfer_Resp()

        resp.order_list = db_helper.query_order_list_alipay_transfer(req.offset, req.num)

        return resp.dump_json()


