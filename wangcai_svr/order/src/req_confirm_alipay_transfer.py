# -*- coding: utf-8 -*-
# 确认转账到支付宝

import web
import logging
import protocol
import db_helper
from data_types import *


logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.ConfirmAlipayTransfer_Req(web.input())
        resp = protocol.ConfirmAlipayTransfer_Resp()

        n = db_helper.confirm_order_alipay_transfer(req.userid, req.serial_num)
        if n == 0:
            resp.rtn = 1
        else:
            db_helper.update_status_order_base(req.userid, req.serial_num, OrderStatus.S_OPERATED)

        return resp.dump_json()
