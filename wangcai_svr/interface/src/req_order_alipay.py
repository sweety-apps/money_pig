# -*- coding: utf-8 -*-

import web
import json
import time
import logging
import protocol
from config import *
from utils import *
from sms_center import SMSCenter

logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.AlipayTransferReq(web.input(), web.cookies())
        resp = protocol.AlipayTransferResp()

        #userid不能为0
        if req.userid == 0:
            resp.res = 1
            return resp.dump_json()

        #查用户信息
        data = {'userid': req.userid, 'device_id': req.device_id}
        url = 'http://' + ACCOUNT_BACKEND + '/user_info?' + urllib.urlencode(data)
        r = http_request(url)
        if r['rtn'] != 0:
            logger.error('get user_info failed! rtn:%d' %r['rtn'])
            resp.res = 1
            return resp.dump_json()

        activate_time = time.mktime(time.strptime(r['activate_time'], '%Y-%m-%d %H:%M:%S'))
        if time.time() - activate_time < 86400:
            logger.error('cannot withdraw in one day! userid:%d, alipay_account:%s' %(req.userid, req.alipay_account))
            resp.res = 1
            resp.msg = '请在首次注册24小时后申请提现'
            return resp.dump_json()


        #先进行资金冻结
        rtn, sn = self.freeze_money(req.userid, req.device_id, req.discount)
        if rtn != 0:
            resp.res = rtn
            return resp.dump_json()
        else:
            #提交订单
            rtn = self.create_order(req.userid, req.device_id, sn, req.amount, req.alipay_account)
            if rtn != 0:
                #订单提交失败,回滚
                self.rollback()
                resp.res = rtn
            else:
                resp.order_id = sn
                #成功,发送短信
                self.confirm_order(req.userid, req.device_id, req.amount/100)

            return resp.dump_json()
        

    def freeze_money(self, userid, device_id, money):
        params = {
            'userid': userid,
            'device_id': device_id,
            'money': money,
            'remark': '支付宝提现'
        }
        
        url = 'http://' + BILLING_BACKEND + '/freeze'

        r = http_request(url, params)
        return r['rtn'], r['serial_num']
        

    def rollback(self, userid, device_id, serial_num):
        params = {
            'userid': userid,
            'device_id': device_id,
            'serial_num': serial_num
        }

        url = 'http://' + BILLING_BACKEND + '/rollback'

        r = http_request(url, params)
        return r['rtn']


    def create_order(self, userid, device_id, serial_num, money, alipay_account):
        params = {
            'userid': userid,
            'device_id': device_id,
            'serial_num': serial_num,
            'money': money,
            'alipay_account': alipay_account
        }

        url = 'http://' + ORDER_BACKEND + '/alipay_transfer'

        r = http_request(url, params)
        return r['rtn']   


    def confirm_order(self, userid, device_id, amount):
        data = {'userid': userid, 'device_id': device_id}
        url = 'http://' + ACCOUNT_BACKEND + '/user_info?' + urllib.urlencode(data)
        r = http_request(url)
        if r['rtn'] != 0:
            logger.error('get user_info failed! rtn:%d' %r['rtn'])
            return

        phone_num = r['phone_num']
        if phone_num == '':
            return

        SMSCenter.instance().confirm_order_alipay(phone_num, amount)


