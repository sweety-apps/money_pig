# -*- coding: utf-8 -*-

from config import *
from utils import *

class Task:
    def __init__(self):
        self.userid = 0
        self.device_id = ''

    def __repr__(self):
        return repr(self.__dict__)

class NewbieTask(Task):
    def __init__(self):
        Task.__init__(self)

class UserInfoTask(Task):
    def __init__(self):
        Task.__init__(self)
    

class TaskClient:

    s_instance = None

    @classmethod
    def instance(cls):
        if cls.s_instance is None:
            cls.s_instance = cls()
        return cls.s_instance


    def __init__(self):
        pass

    def make_request(uri, query):
        url = 'http://' + TASK_BACKEND + uri + '?' + query
        


    def report_task_newbie(self, task):


    def report_task_userinfo(self):

