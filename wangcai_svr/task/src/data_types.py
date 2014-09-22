# -*- coding: utf-8 -*-

class TaskType:
    '''任务类型定义,10000以内为预制任务
       1 - 安装旺财
       2 - 填写个人资料
       3 - 邀请好友
       4 - 每日签到
       10000 - 积分墙应用安装任务
    '''
    T_NEWBIE  = 1
    T_INFO    = 2
    T_INVITE  = 3
    T_CHECKIN = 4
    T_OFFERWALL = 5
    T_COMMENT = 6
    T_BUILTIN = 9999
    T_APP = 10000

class TaskStatus:
    S_NORMAL = 0
    S_DONE = 10
    S_CANCEL = 100


class Task:
    ID_NEWBIE  = 1
    ID_INFO    = 2
    ID_INVITE  = 3
    ID_CHECKIN = 4
    ID_OFFERWALL = 5
    ID_COMMENT = 6

    def __init__(self):
        self.id     = 0
        self.type   = 0
        self.status = 0
        self.title  = ''
        self.icon   = ''
        self.intro  = ''
        self.desc   = ''
        self.steps  = None
        self.money  = 0
        self.timestamp = 0


class TaskApp:
    def __init__(self):
        self.id         = 0
        self.appid      = ''
        self.app_name   = ''
        self.download_url = ''
        self.redirect_url = ''
        self.icon       = ''
        self.genre      = 0
        self.filesize   = 0
        self.version    = ''
        self.screenshots = ''
        self.intro      = ''
        self.last_update = ''
        self.score      = 0
        self.download_times = 0
        self.corp_id    = 0
        self.corp       = ''
        self.site       = ''
        self.contact    = ''
        self.money      = 0


class TaskOfDevice:
    def __init__(self):
        self.device_id = ''
        self.userid = 0
        self.task_id = 0
        self.type = 0
        self.status = 0
        self.money = 0


class TaskOfUser:
    def __init__(self):
        self.userid = 0
        self.device_id = ''
        self.task_id = 0
        self.type = 0
        self.status = 0
        self.money = 0


class TaskInvite:
    def __init__(self):
        self.userid = 0
        self.invitee = 0
        self.invite_code = ''

class TaskUserInfo:
    def __init__(self):
        self.device_id = ''
        self.userid = 0
        self.task_id = 0

class TaskCheckIn:
    def __init__(self):
        self.device_id = ''
        self.userid = 0
        self.money = 0
        self.extra = ''


class OfferWallType:
    T_DOMOB = 0
    T_YOUMI = 1
