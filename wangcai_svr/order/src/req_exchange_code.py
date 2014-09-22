# -*- coding: utf-8 -*-
# 换购各类码

import web
import logging
import protocol
import db_helper
from data_types import *

logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.ExchangeCode_Req(web.input())
        resp = protocol.ExchangeCode_Resp()

        order = OrderExchangeCode()
        order.userid = req.userid
        order.device_id = req.device_id
        order.serial_num = req.serial_num
        order.status = OrderStatus.S_OPERATED

        if req.exchange_type == ExchangeType.T_JINGDONG:
            #获取1个可用兑换码
            code = db_helper.get_available_exchange_code_jingdong()
            if code == '':
                logger.error('no available exchange_code_jingdong!!')
                resp.rtn = 1
                return resp.dump_json()

            order.money = 4500
            order.exchange_type = ExchangeType.T_JINGDONG
            order.exchange_code = code

        elif req.exchange_type == ExchangeType.T_XLVIP:
            #获取1个可用的xlvip激活码
            code = db_helper.get_available_exchange_code_xlvip()
            if code == '':
                logger.error('no available exchange_code_xlvip!!')
                resp.rtn = 1
                return resp.dump_json()

            order.money = 800
            order.exchange_type = ExchangeType.T_XLVIP
            order.exchange_code = code

        else:
            resp.rtn = 2
            return resp.dump_json()
            

        db_helper.insert_order_base(order)
        
        db_helper.create_order_exchange_code(order)

        resp.exchange_code = code

        return resp.dump_json()

