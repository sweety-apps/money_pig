# -*- coding: utf-8 -*-

class UserInfo:
    def __init__(self):
        self.userid = 0
        self.phone_num = ''
        self.nickname = ''
        self.sex = 0
        self.age = 0
        self.interest = ''
        self.invite_code = ''
        self.inviter_id = 0
        self.inviter_code = ''
        self.create_time = ''


class UserDevice:
    def __init__(self):
        self.device_id = ''
        self.mac = ''
        self.idfa = ''
        self.platform = ''
        self.userid = 0
        self.status = 0


class AnonymousDevice:
    def __init__(self):
        self.device_id = ''
        self.mac = ''
        self.idfa = ''
        self.platform = ''
        self.flag = 0
        self.sex = 0
        self.age = 0
        self.interest = ''
        self.activate_time = ''


class LoginHistory:
    def __init__(self):
        self.userid = 0
        self.device_id = ''
        self.platform = ''
        self.version = ''
        self.ip = ''
        self.network = ''
