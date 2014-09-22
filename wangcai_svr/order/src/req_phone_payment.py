# -*- coding: utf-8 -*-
# 充值到手机

import web
import logging
import protocol
import db_helper
from data_types import *


logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.PhonePayment_Req(web.input())
        resp = protocol.PhonePayment_Resp()

        order = OrderPhonePayment()
        order.userid = req.userid
        order.device_id = req.device_id
        order.serial_num = req.serial_num
        order.money = req.money
        order.phone_num = req.phone_num

        db_helper.insert_order_base(order)

        db_helper.create_order_phone_payment(order)

        return resp.dump_json()

