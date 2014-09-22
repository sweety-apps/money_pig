# -*- coding: utf-8 -*-

import web
import json
import logging
from Crypto.Cipher import AES
from config import *

class Request(object):
    def __init__(self, input, cookies):
        self.platform = ''
        self.app = ''
        self.network = ''
        self.ip = ''
        self.input = input

    def session_id(self):
        return self.input.get('session_id', '')
    def device_id(self):
        return self.input.get('device_id', '')
    def userid(self):
        uid = self.input.get('userid', '')
        return uid.isdigit() and int(uid) or 0

    def get(self, key, default=''):
        return self.input.get(key, default)

    def get_int(self, key, default=0):
        n = self.input.get(key, '')
        return n.isdigit() and int(n) or default


class Response(object):
    def __init__(self):
        self.res = 0
        self.msg = ''

    def dump_json(self):
        return json.dumps(self.__dict__, ensure_ascii=False, indent=2)

#############################################

class RegisterReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        self.idfa = self.get('idfa').upper()
        self.mac = self.get('mac').upper()

class RegisterResp(Response):
    def __init__(self):
        Response.__init__(self)
        self.session_id = ''
        self.device_id = ''
        self.invite_code = ''
        self.userid = 0
        self.phone = ''
        self.inviter = ''
        self.balance = 0
        self.income = 0
        self.outgo = 0
        self.recent_income = 0
        self.shared_income = 0
        self.force_update = 0
        self.task_list = []
        self.no_withdraw = 0
        self.offerwall = {}
        self.tips = ''

#############################################

class UpdateInviterReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        self.session_id = input.session_id
        self.device_id = input.device_id
        self.userid = int(input.userid)
        self.inviter = input.inviter

class UpdateInviterResp(Response):
    def __init__(self):
        Response.__init__(self)

#############################################

class ResendSmsCodeReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        self.session_id = input.session_id
        self.device_id = input.device_id
        self.userid = int(input.userid)
        self.token = input.token
        self.code_len = int(input.code_length)

class ResendSmsCodeResp(Response):
    def __init__(self):
        Response.__init__(self)
        self.token = ''

#############################################

class TaskListReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        self.session_id = input.session_id
        self.device_id = input.device_id
        self.userid = int(input.userid)

class TaskListResp(Response):
    def __init__(self):
        Response.__init__(self)
        self.task_list = []

#############################################

class TaskDetailReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        self.session_id = input.get('session_id', '')
        self.device_id = input.get('device_id', '')
        self.userid = int(input.get('userid', '0'))
        self.task_id = int(input.task_id)

class TaskDetailResp(Response):
    def __init__(self):
        Response.__init__(self)
        self.task = {}

#############################################

class CheckInReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        self.session_id = self.session_id()
        self.device_id = self.device_id()
        self.userid = self.userid()

class CheckInResp(Response):
    def __init__(self):
        Response.__init__(self)
        self.award = 0

#############################################

class DownloadAppReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        self.session_id = self.session_id()
        self.device_id = self.device_id()
        self.userid = self.userid()
        self.appid = self.input.appid

class DownloadAppResp(Response):
    def __init__(self):
        Response.__init__(self)

#############################################

class AppCallbackReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        self.appid = input.get('appid', '')
        self.idfa = input.get('idfa', '')
        self.mac = input.get('mac', '')

class AppCallbackResp(Response):
    def __init__(self):
        Response.__init__(self)
        
#############################################

class ReportDomobPointReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        self.session_id = self.session_id()
        self.device_id = self.device_id()
        self.userid = self.userid()
        self.type = int(input.get('type', 0))
        self.point = int(input.input.point)

class ReportDomobPointResp(Response):
    def __init__(self):
        Response.__init__(self)
        self.increment = 0


#############################################

class ReportOfferWallPointReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        logger = logging.getLogger('ReportOfferWallPointReq')
        self.session_id = self.session_id()
        self.device_id = self.device_id()
        self.userid = self.userid()
#        cryptor = AES.new(AES_KEY)
#        data = web.data()
#        hex = ' '.join(["%02x" % ord(x) for x in data])
#        logger.debug('report offerwall, len: %d, data: %s' %(len(data), hex))
#        plain_data = cryptor.decrypt(data)
#        logger.debug('after decrypt, plain_data: %s' %plain_data)
        self.domob_point = int(input.get('domob_point', 0))
        self.youmi_point = int(input.get('youmi_point', 0))

class ReportOfferWallPointResp(Response):
    def __init__(self):
        Response.__init__(self)
        self.income = 0

#############################################

class ReportCommentReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        self.session_id = self.session_id()
        self.device_id = self.device_id()
        self.userid = self.userid()

class ReportCommentResp(Response):
    def __init__(self):
        Response.__init__(self)
        self.income = 0

#############################################

class AlipayTransferReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        self.session_id = self.session_id()
        self.device_id = self.device_id()
        self.userid = self.userid()
        self.amount = int(input.get('amount', 0))
        self.discount = int(input.get('discount', 0))
        self.alipay_account = input.alipay_account

class AlipayTransferResp(Response):
    def __init__(self):
        Response.__init__(self)
        self.order_id = ''

#############################################

class PhonePayReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        self.session_id = self.session_id()
        self.device_id = self.device_id()
        self.userid = self.userid()
        self.amount = int(input.get('amount', 0))
        self.discount = int(input.get('discount', 0))
        self.phone_num = input.phone_num

class PhonePayResp(Response):
    def __init__(self):
        Response.__init__(self)
        self.order_id = ''

#############################################

class ExchangeListReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        self.session_id = self.session_id()
        self.device_id = self.device_id()
        self.userid = self.userid()

class ExchangeListResp(Response):
    def __init__(self):
        Response.__init__(self)
        self.exchange_list = []


#############################################

class ExchangeCodeReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        self.session_id = self.session_id()
        self.device_id = self.device_id()
        self.userid = self.userid()
        self.exchange_type = int(input.exchange_type)

class ExchangeCodeResp(Response):
    def __init__(self):
        Response.__init__(self)
        self.order_id = ''
        self.exchange_code = ''


#############################################


class OrderDetailReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        self.session_id = self.session_id()
        self.device_id = self.device_id()
        self.userid = self.userid()
        self.order_id = input.order_id

class OrderDetailResp(Response):
    def __init__(self):
        Response.__init__(self)
        self.type = 0
        self.status = 0
        self.money = 0
        self.create_time = ''
        self.confirm_time = ''
        self.complete_time = ''
        self.extra = ''


#############################################

class BillingHistoryReq(Request):
    def __init__(self, input, cookies):
        Request.__init__(self, input, cookies)
        self.session_id = self.session_id()
        self.device_id = self.device_id()
        self.userid = self.userid()
        self.offset = int(input.offset)
        self.num = int(input.num)

class BillingHistoryResp(Response):
    def __init__(self):
        Response.__init__(self)
        self.history = []

