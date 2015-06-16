# -*- coding: utf-8 -*-
# 订单详情

import web
import json
import logging
import protocol
import db_helper
from data_types import *


logger = logging.getLogger()

class Handler:
    def GET(self):
        req  = protocol.OrderDetail_Req(web.input())
        resp = protocol.OrderDetail_Resp()

        order_base = db_helper.query_order_base(req.userid, req.order_id)
        if order_base is None:
            logger.error('no such order!! userid:%d, order_id:%s' %(req.userid, req.order_id))
            resp.rtn = 2
            return resp.dump_json()

        if order_base.type == OrderType.T_ALIPAY_TRANSFER:
            order = db_helper.query_order_alipay_transfer(req.userid, req.order_id)
            if order is None:
                resp.rtn = 2
            else:
                resp.name = '提现到支付宝余额'
                resp.userid = req.userid
                resp.device_id = order.device_id
                resp.serial_num = order.serial_num
                resp.type = order.type
                resp.status = order.status
                resp.money = order.money
                resp.create_time = order.create_time
                resp.confirm_time = order.confirm_time
                resp.operate_time = order.operate_time
                resp.extra = order.alipay_account
                resp.exchange_type = order.exchange_type

        elif order_base.type == OrderType.T_PHONE_PAYMENT:
            order = db_helper.query_order_phone_payment(req.userid, req.order_id)
            if order is None:
                resp.rtn = 2
            else:
                resp.name = '手机话费充值'
                resp.userid = req.userid
                resp.device_id = order.device_id
                resp.serial_num = order.serial_num
                resp.type = order.type
                resp.status = order.status
                resp.money = order.money
                resp.create_time = order.create_time
                resp.confirm_time = order.confirm_time
                resp.operate_time = order.operate_time
                resp.extra = order.phone_num
                resp.exchange_type = order.exchange_type
                
        elif order_base.type == OrderType.T_EXCHANGE_CODE:
            order = db_helper.query_order_exchange_code(req.userid, req.order_id)
            if order is None:
                resp.rtn = 2
            else:
                resp.name = '兑换码'
                if order.exchange_type == ExchangeType.T_JINGDONG:
                    resp.name = '京东余额充值卡'
                elif order.exchange_type == ExchangeType.T_XLVIP:
                    resp.name = '迅雷VIP会员充值卡'
                resp.userid = req.userid
                resp.device_id = order.device_id
                resp.serial_num = order.serial_num
                resp.type = order.type
                resp.status = order.status
                resp.money = order.money
                resp.create_time = order.create_time
                resp.confirm_time = order.confirm_time
                resp.operate_time = order.operate_time
                resp.extra = json.dumps({'type':order.exchange_type, 'code':order.exchange_code})
                resp.exchange_type = order.exchange_type

        else:
            resp.rtn = 2

        return resp.dump_json()


