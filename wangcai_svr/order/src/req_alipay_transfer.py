# -*- coding: utf-8 -*-
# 转账到支付宝

import web
import logging
import protocol
import db_helper
from data_types import *


logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.AlipayTransfer_Req(web.input())
        resp = protocol.AlipayTransfer_Resp()

        order = OrderAlipayTransfer()
        order.userid = req.userid
        order.device_id = req.device_id
        order.serial_num = req.serial_num
        order.money = req.money
        order.alipay_account = req.alipay_account

        db_helper.insert_order_base(order)

        db_helper.create_order_alipay_transfer(order)

        return resp.dump_json()
            
            
        
