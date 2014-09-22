# -*- coding: utf-8 -*-

import redis
from config import *
from task_msg import *


class TaskMQ:

    s_instance = None

    @classmethod
    def instance(cls):
        if cls.s_instance is None:
            cls.s_instance = cls()
        return cls.s_instance


    def __init__(self):
        self._rc = redis.Redis(host=TASK_MQ_HOST, port=TASK_MQ_PORT, socket_timeout=2)

    def publish(self, msg):
        try:
            return self._rc.publish(TASK_MQ_CHANNEL, msg)
        except:
            return -1

