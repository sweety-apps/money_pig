# -*- coding: utf-8 -*-

import web
import json
import logging
import protocol
from billing_client import *
from order_client import *
from ofpay_client import *
from account_client import *
from sms_center import *

logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.OrderAlipayPerform_Req()
        resp = protocol.OrderAlipayPerform_Resp()

        #查询订单详情
        rtn, order = OrderClient.instance().order_detail(req.userid, req.order_id)
        if rtn != 0 or order is None:
            logger.error('query order detail failed!! rtn:%d, userid:%d, order_id:%s' %(rtn, req.userid, req.order_id))
            resp.rtn = rtn
            return resp.dump_json()
        elif order.type != OrderType.T_ALIPAY:
            logger.error('unexpected order type, %d' %order.type)
            resp.rtn = 3
            resp.msg = '订单类型错误'
            return resp.dump_json()
        elif order.status not in [OrderStatus.S_PENDING, OrderStatus.S_CONFIRMED]:
            logger.error('order status error! status:%d' %order.status)
            resp.rtn = 4
            resp.msg = '订单状态错误'
            return resp.dump_json()

        logger.debug('alipay perform, step 1, userid:%d, order_id:%s, alipay_account:%s' %(req.userid, req.order_id, order.extra))
        
        alipay_account = order.extra
        amount = order.money / 100

        self.init_bad_list()
        if req.userid in self._bad_user:
            logger.info('BAD USER! userid:%d' %req.userid)
            resp.rtn = 8
            resp.msg = '被屏蔽用户'
            return resp.dump_json()
        elif alipay_account in self._bad_alipay:
            logger.info('BAD ALIPAY! userid:%d, alipay_account:%s' %(req.userid, alipay_account))
            resp.rtn = 9
            resp.msg = '被屏蔽的支付宝账户! %s' %alipay_account
            return resp.dump_json()

        #支付宝转账
        rtn, msg = OfpayClient.instance().alipay(alipay_account, amount, order.serial_num, order.create_time)
        if rtn != 0:
            logger.error('alipay perform failed! account:%s, amount:%d, msg:%s' %(alipay_account, amount, msg))
            resp.rtn = 5
            resp.msg = '转账失败,' + msg
            return resp.dump_json()

        logger.debug('alipay perform, step 2, account:%s, amount:%d, msg:%s' %(alipay_account, amount, msg))

        #提交
        rtn = BillingClient.instance().commit(order.userid, order.device_id, order.serial_num)
        if rtn != 0:
            logger.error('commit failed! userid:%d, serial_num:%s' %(order.userid, order.serial_num))
            resp.rtn = 7
            resp.msg = '提交失败'
            return resp.dump_json()

        logger.debug('alipay perform, step 3, commit success')

        #修改订单状态
        rtn = OrderClient.instance().confirm_order_alipay(req.userid, req.order_id)
        if rtn != 0:
            logger.error('confirm order failed! userid:%d, order_id:%s' %(req.userid, req.order_id))

        self.send_sms(req.userid, req.order_id[:14], amount)

        return resp.dump_json()

    def init_bad_list(self):
        fp = open('../conf/bad_user.txt')
        self._bad_user = [int(line.strip()) for line in fp.readlines() if line.strip() != '' and not line.startswith('#')]
        fp.close()
        fp = open('../conf/bad_alipay.txt')
        self._bad_alipay = [line.strip() for line in fp.readlines() if line.strip() != '' and not line.startswith('#')]
        fp.close()

    def send_sms(self, userid, order_id, amount):
        #查手机号
        user_info = AccountClient.instance().user_info(userid)
        if user_info is None:
            logger.error('query user_info failed! userid:%d' %userid)
            return

        phone_num = user_info['phone_num']
        if phone_num == '':
            return

        SMSCenter.instance().notify_order_alipay(phone_num, order_id, amount)



