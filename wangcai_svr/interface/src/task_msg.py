# -*- coding: utf-8 -*-

class TaskMsg:
    def __init__(self):
        self.userid = 0
        self.device_id = ''

    def __repr__(self):
        return repr(self.__dict__)

class TaskMsg_Newbie(TaskMsg):
    def __init__(self):
        TaskMsg.__init__(self)

class TaskMsg_UserInfo(TaskMsg):
    def __init__(self):
        TaskMsg.__init__(self)


