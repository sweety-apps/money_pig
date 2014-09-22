# -*- coding: utf-8 -*-

import web
import json
import logging

class Request(object):
    def __init__(self):
        self.input = web.input()

    def get(self, key, default=''):
        return self.input.get(key, default)

    def get_int(self, key, default=0):
        n = self.input.get(key, '')
        return n.isdigit() and int(n) or default
        

class Response(object):
    def __init__(self):
        self.rtn = 0
        self.msg = ''

    def dump_json(self):
        return json.dumps(self.__dict__, ensure_ascii=False, indent=2)


######################################

class OrderList_Req(Request):
    def __init__(self):
        Request.__init__(self)
        self.offset = self.get_int('offset')
        self.num = self.get_int('num')

class OrderList_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self.order_list = []


######################################

class OrderAlipayList_Req(Request):
    def __init__(self):
        Request.__init__(self)
        self.offset = self.get_int('offset')
        self.num = self.get_int('num')

class OrderAlipayList_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self.order_list = []

######################################

class OrderAlipayPerform_Req(Request):
    def __init__(self):
        Request.__init__(self)
        self.userid = self.get_int('userid')
        self.order_id = self.get('order_id')

class OrderAlipayPerform_Resp(Response):
    def __init__(self):
        Response.__init__(self)

######################################

class OrderPhoneCharge_Req(Request):
    def __init__(self):
        Request.__init__(self)
        self.userid = self.get_int('userid')
        self.order_id = self.get('order_id')

class OrderPhoneCharge_Resp(Response):
    def __init__(self):
        Response.__init__(self)

