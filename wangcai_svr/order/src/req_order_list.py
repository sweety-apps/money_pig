# -*- coding: utf-8 -*-
# 待处理订单列表

import web
import logging
import protocol
import db_helper
from data_types import *


logger = logging.getLogger()

class Handler:
    def GET(self):
        req  = protocol.OrderList_Req(web.input())
        resp = protocol.OrderList_Resp()

        resp.order_list = db_helper.query_order_list(req.offset, req.num)

        return resp.dump_json()
