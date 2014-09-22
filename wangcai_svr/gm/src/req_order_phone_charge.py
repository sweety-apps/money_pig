# -*- coding: utf-8 -*-

import web
import json
import logging
import protocol
from billing_client import *
from order_client import *
from ofpay_client import *

logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.OrderPhoneCharge_Req()
        resp = protocol.OrderPhoneCharge_Resp()
        
        #查询订单详情
        rtn, order = OrderClient.instance().order_detail(req.userid, req.order_id)
        if rtn != 0 or order is None:
            logger.error('query order detail failed!! rtn:%d, userid:%d, order_id:%s' %(rtn, req.userid, req.order_id))
            resp.rtn = rtn
            return resp.dump_json()
        elif order.type != OrderType.T_PHONE_PAY:
            logger.error('unexpected order type, %d' %order.type)
            resp.rtn = 3
            resp.msg = '订单类型错误'
            return resp.dump_json()
        elif order.status not in [OrderStatus.S_PENDING, OrderStatus.S_CONFIRMED]:
            logger.error('order status error! status:%d' %order.status)
            resp.rtn = 4
            resp.msg = '订单状态错误'
            return resp.dump_json()

        logger.debug('phone charge, step 1, userid:%d, order_id:%s, phone_num:%s' %(req.userid, req.order_id, order.extra))

        phone_num = order.extra
        amount = order.money / 100

        #查询是否可充值
        rtn, msg = OfpayClient.instance().telcheck(phone_num, amount)
        if rtn != 0:
            logger.error('telcheck failed! phone:%s, amount:%d' %(phone_num, amount))
            resp.rtn = 5
            resp.msg = msg
            return resp.dump_json()

        logger.debug('phone charge, step 2, telcheck success, phone_num:%s, amount:%d, msg:%s' %(phone_num, amount, msg))

        #进行充值操作
#        rtn, msg = OfpayClient.instance().charge(phone_num, amount, order.serial_num, order.create_time)
#        if rtn != 0:
#            logger.error('charge failed! phone:%s, amount:%d, msg:%s' %(phone_num, amount, msg))
#            resp.rtn = 6
#            resp.msg = '充值失败,' + msg
#            return resp.dump_json()

        logger.debug('phone charge, step 3, charge success, phone_num:%s, amount:%d, msg:%s' %(phone_num, amount, msg))

        #提交
        rtn = BillingClient.instance().commit(order.userid, order.device_id, order.serial_num)
        if rtn != 0:
            logger.error('commit failed! userid:%d, serial_num:%s' %(order.userid, order.serial_num))
            resp.rtn = 7
            resp.msg = '提交失败'
            return resp.dump_json()

        logger.debug('phone charge, step 4, commit success')

        #修改订单状态
        rtn = OrderClient.instance().confirm_order_phone_charge(req.userid, req.order_id)
        if rtn != 0:
            logger.error('confirm order failed! userid:%d, order_id:%s' %(req.userid, req.order_id))

        return resp.dump_json()


