# -*- coding: utf-8 -*-

import web
import json
import logging
import protocol
from config import *
from utils import *
from billing_client import *
from session_manager import SessionManager
from sms_center import SMSCenter

logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.ExchangeCodeReq(web.input(), web.cookies())
        resp = protocol.ExchangeCodeResp()

        if not SessionManager.instance().check_session(req.session_id, req.device_id, req.userid):
            resp.res = 401
            resp.msg = '登陆态异常'
            return resp.dump_json()

        #userid不能为0
        if req.userid == 0:
            resp.res = 1
            return resp.dump_json()

        if req.exchange_type == 1:
            rtn, sn, code = self.get_exchange_code_jingdong(req.userid, req.device_id)
        elif req.exchange_type == 2:
            rtn, sn, code = self.get_exchange_code_xlvip(req.userid, req.device_id)
        else:
            resp.res = 1
            return resp.dump_json()

        if rtn != 0:
            resp.res = rtn
            return resp.dump_json()

        #成功,发送短信
        self.notify_exchange_code(req.userid, req.device_id, req.exchange_type, code)
        
        resp.order_id = sn
        resp.exchange_code = code
        return resp.dump_json()


    def create_order(self, userid, device_id, serial_num, exchange_type, price):
        params = {
            'userid': userid,
            'device_id': device_id,
            'serial_num': serial_num,
            'money': price,
            'exchange_type': exchange_type
        }

        url = 'http://' + ORDER_BACKEND + '/exchange_code'

        r = http_request(url, params)
        return r['rtn'], r['exchange_code']


    def get_exchange_code_jingdong(self, userid, device_id):
        price = 4500  #京东兑换码,折后45元
        #冻结
        rtn, sn = BillingClient.instance().freeze(userid, device_id, price, '兑换50元京东礼品卡')
        if rtn != 0:
            return 1, '', ''
        else:
            #提交订单
            rtn, code = self.create_order(userid, device_id, sn, 1, price)
            if rtn != 0:
                BillingClient.instance().rollback(userid, device_id, sn)
                return rtn, '', ''
            else:
                BillingClient.instance().commit(userid, device_id, sn)
                return 0, sn, code


    def get_exchange_code_xlvip(self, userid, device_id):
        price = 800 #迅雷会员卡,8元
        #冻结
        rtn, sn = BillingClient.instance().freeze(userid, device_id, price, '兑换迅雷白金月卡')
        if rtn != 0:
            return 1, '', ''
        else:
            #提交订单
            rtn, code = self.create_order(userid, device_id, sn, 2, price)
            if rtn != 0:
                BillingClient.instance().rollback(userid, device_id, sn)
                return rtn, '', ''
            else:
                BillingClient.instance().commit(userid, device_id, sn)
                return 0, sn, code
        
            
    def notify_exchange_code(self, userid, device_id, exchange_type, exchange_code):
        data = {'userid': userid, 'device_id': device_id}
        url = 'http://' + ACCOUNT_BACKEND + '/user_info?' + urllib.urlencode(data)
        r = http_request(url)
        if r['rtn'] != 0:
            logger.error('get user_info failed! rtn:%d' %r['rtn'])
            return

        phone_num = r['phone_num']
        if phone_num == '':
            return

        if exchange_type == 1:
            exchange_desc = '50元京东礼品卡'
        else:
            exchange_desc = '迅雷白金月卡'
            
        SMSCenter.instance().notify_exchange_code(phone_num, exchange_desc, exchange_code)
        


        
        

