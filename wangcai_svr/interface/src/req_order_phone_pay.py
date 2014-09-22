# -*- coding: utf-8 -*-

import web
import json
import logging
import protocol
from config import *
from utils import *
from billing_client import *
from sms_center import SMSCenter

logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.PhonePayReq(web.input(), web.cookies())
        resp = protocol.PhonePayResp()

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
            logger.error('cannot withdraw in one day! userid:%d, phone_num:%s' %(req.userid, req.phone_num))
            resp.res = 1
            resp.msg = '请在首次注册24小时后申请提现'
            return resp.dump_json()


        #冻结
        rtn, sn = BillingClient.instance().freeze(req.userid, req.device_id, req.discount, '兑换%d元话费' %(req.amount/100))
        if rtn != 0:
            resp.res = rtn
            return resp.dump_json()

        #提交订单
        rtn = self.create_order(req.userid, req.device_id, sn, req.amount, req.phone_num)
        if rtn != 0:
            resp.res = rtn
#            BillingClient.instance().rollback()
        else:
            resp.order_id = sn
            #成功,发送短信
            self.confirm_order(req.userid, req.device_id, req.amount/100)

        return resp.dump_json()

        
    def create_order(self, userid, device_id, serial_num, money, phone_num):
        params = {
            'userid': userid,
            'device_id': device_id,
            'serial_num': serial_num,
            'money': money,
            'phone_num': phone_num
        }

        url = 'http://' + ORDER_BACKEND + '/phone_payment'

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

        SMSCenter.instance().confirm_order_phone_charge(phone_num, amount)
        

