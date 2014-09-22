
import json
from data_types import *


class Request(object):
    def __init__(self, input):
        pass

class Response(object):
    def __init__(self):
        self.rtn = 0

    @staticmethod
    def __json_encode(o):
        if isinstance(o, Task):
            return o.__dict__
        elif isinstance(o, TaskApp):
            return o.__dict__
        raise TypeError('type error!! ' + str(type(o)))

    def dump_json(self):
#        return json.dumps(self.__dict__, ensure_ascii=False)
        return json.dumps(self.__dict__, ensure_ascii=False, default=Response.__json_encode)

######################################

class ListTaskOfDevice_Req(Request):
    def __init__(self, input):
        Request.__init__(self, input)
        self.device_id = input.device_id

class ListTaskOfDevice_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self.task_list = []

######################################

class ListTaskOfUser_Req(Request):
    def __init__(self, input):
        Request.__init__(self, input)
        self.userid = int(input.userid)

class ListTaskOfUser_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self.task_list = []

######################################

class GetTaskDetail_Req(Request):
    def __init__(self, input):
        Request.__init__(self, input)
        self.device_id = input.device_id
        self.userid = int(input.userid)
        self.task_id = int(input.task_id)

class GetTaskDetail_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self.task = {}
        

######################################

class ReportInvite_Req(Request):
    def __init__(self, input):
        Request.__init__(self, input)
        self.userid = int(input.userid)
        self.invitee = int(input.invitee)
        self.invite_code = input.invite_code

class ReportInvite_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self.total_invite = 0

######################################

class ReportUserInfo_Req(Request):
    def __init__(self, input):
        Request.__init__(self, input)
        self.device_id = input.device_id
        self.userid = int(input.userid)

class ReportUserInfo_Resp(Response):
    def __init__(self):
        Response.__init__(self)

######################################

class ReportComment_Req(Request):
    def __init__(self, input):
        Request.__init__(self, input)
        self.device_id = input.device_id
        self.userid = int(input.userid)

class ReportComment_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self.income = 0

######################################

class ReportOfferWall_Req(Request):
    def __init__(self, input):
        Request.__init__(self, input)
        self.device_id = input.device_id
        self.userid = int(input.userid)
        self.type = int(input.type)
        self.increment = int(input.increment)
        self.inviter = int(input.inviter)

class ReportOfferWall_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self.income = 0

######################################

class ReportDomobPoint_Req(Request):
    def __init__(self, input):
        Request.__init__(self, input)
        self.device_id = input.device_id
        self.userid = int(input.userid)
        self.point = int(input.point)
        self.inviter = int(input.inviter)

class ReportDomobPoint_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self.increment = 0

######################################

class ReportYoumiPoint_Req(Request):
    def __init__(self, input):
        Request.__init__(self, input)
        self.device_id = input.device_id
        self.userid = int(input.userid)
        self.point = int(input.point)
        self.inviter = int(input.inviter)

class ReportYoumiPoint_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self.increment = 0

######################################

class CheckIn_Req(Request):
    def __init__(self, input):
        Request.__init__(self, input)
        self.device_id = input.device_id
        self.userid = int(input.userid)

class CheckIn_Resp(Response):
    def __init__(self):
        Response.__init__(self)
        self.award = 0

######################################

class AppDownload_Req(Request):
    def __init__(self, input):
        Request.__init__(self, input)
        self.device_id = input.device_id
        self.userid = int(input.userid)
        self.appid = input.appid

class AppDownload_Resp(Response):
    def __init__(self):
        Response.__init__(self)

######################################

class AppCallback_Req(Request):
    def __init__(self, input):
        Request.__init__(self, input)
        self.device_id = input.device_id
        self.userid = int(input.userid)
        self.appid = input.appid

class AppCallback_Resp(Response):
    def __init__(self):
        Response.__init__(self)

