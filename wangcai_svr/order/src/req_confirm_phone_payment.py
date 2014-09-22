# -*- coding: utf-8 -*-
# 确认话费充值订单

import web
import logging
import protocol
import db_helper
from data_types import *


logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.ConfirmPhonePayment_Req(web.input())
        resp = protocol.ConfirmPhonePayment_Resp()

        n = db_helper.confirm_order_phone_payment(req.userid, req.serial_num)
        if n == 0:
            resp.rtn = 1
        else:
            db_helper.update_status_order_base(req.userid, req.serial_num, OrderStatus.S_OPERATED)

        return resp.dump_json()
