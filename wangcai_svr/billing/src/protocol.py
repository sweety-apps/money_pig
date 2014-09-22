
import json
from data_types import *

class Request(object):
    def __init__(self):
        pass

class Response(object):
    def __init__(self):
        self.rtn = 0

    @staticmethod
    def __json_encode(o):
        if isinstance(o, BillingLog):
            return o.__dict__
        raise TypeError('type error!! ' + str(type(o)))

    def dump_json(self):
        return json.dumps(self.__dict__, ensure_ascii=False, default=Response.__json_encode)

######################################

class ActivateAccount_Req(Request):
    def __init__(self, input):
        Request.__init__(self)
        self.device_id = input.device_id
        self.userid = int(input.userid)

class ActivateAccount_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self.balance = 0
        self.income = 0
        self.outgo = 0
        
######################################

class QueryBalance_Req(Request):
    def __init__(self, input):
        Request.__init__(self)
        self.device_id = input.device_id
        self.userid = int(input.userid)

class QueryBalance_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self.balance = 0
        self.income = 0
        self.outgo = 0
        self.shared_income = 0

######################################

class Recharge_Req(Request):
    def __init__(self, input):
        Request.__init__(self)
        self.device_id = input.device_id
        self.userid = int(input.userid)
        self.money = int(input.money)
        self.remark = input.remark

class Recharge_Resp(Response):
    def __init__(self):
        Response.__init__(self)

######################################

class Freeze_Req(Request):
    def __init__(self, input):
        Request.__init__(self)
        self.userid = int(input.userid)
        self.device_id = input.device_id
        self.money = int(input.money)
        self.remark = input.remark

class Freeze_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self.serial_num = ''

######################################

class Commit_Req(Request):
    def __init__(self, input):
        Request.__init__(self)
        self.userid = int(input.userid)
        self.device_id = input.device_id
        self.serial_num = input.serial_num

class Commit_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        
######################################

class Rollback_Req(Request):
    def __init__(self, input):
        Request.__init__(self)
        self.userid = int(input.userid)
        self.device_id = input.device_id
        self.serial_num = input.serial_num

class Rollback_Resp(Response):
    def __init__(self):
        Response.__init__(self)

######################################

class QueryHistory_Req(Request):
    def __init__(self, input):
        Request.__init__(self)
        self.userid = int(input.userid)
        self.device_id = input.device_id
        self.offset = int(input.offset)
        self.num = int(input.num)

class QueryHistory_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self.history = []

######################################

class SharedIncome_Req(Request):
    def __init__(self, input):
        Request.__init__(self)
        self.userid = int(input.userid)
        self.money = int(input.money)

class SharedIncome_Resp(Response):
    def __init__(self):
        Response.__init__(self)
