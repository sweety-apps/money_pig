# -*- coding: utf-8 -*-

import web
import json
import logging
import protocol
from order_client import *

logger = logging.getLogger()

class Handler:
    def GET(self):
        req  = protocol.OrderList_Req()
        resp = protocol.OrderList_Resp()

        #查询订单列表
        rtn, order_list = OrderClient.instance().order_list(req.offset, req.num)
        if rtn != 0 or order_list is None:
            logger.error('query orderlist failed!! rtn:%d' %rtn)
            resp.rtn = rtn
        else:
            resp.order_list = order_list

        return resp.dump_json()

