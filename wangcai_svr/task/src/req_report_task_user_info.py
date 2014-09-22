# -*- coding: utf-8 -*-
# 填写个人资料任务

import web
import logging
import protocol
import db_helper
from config import *
from data_types import *
from billing_client import BillingClient

logger = logging.getLogger()

class Handler:
    def POST(self):
        req = protocol.ReportUserInfo_Req(web.input())
        resp = protocol.ReportUserInfo_Resp()

        if req.userid == 0:
            task = TaskOfDevice()
            task.device_id = req.device_id
            task.task_id = Task.ID_INFO
            task.type = TaskType.T_INFO
            task.status = TaskStatus.S_DONE
            task.money = TASK_REWARD_INFO
            n = db_helper.insert_task_of_device(task)
        else:
            task = TaskOfUser()
            task.userid = req.userid
            task.device_id = req.device_id
            task.task_id = Task.ID_INFO
            task.type = TaskType.T_INFO
            task.status = TaskStatus.S_DONE
            task.money = TASK_REWARD_INFO
            n = db_helper.insert_task_of_user(task)

        if n > 0:
            #奖励1元
            BillingClient.instance().recharge(req.device_id, req.userid, TASK_REWARD_INFO, '填写个人资料')

        return resp.dump_json()


