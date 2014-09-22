# -*- coding: utf-8 -*-

import web
import logging
import protocol
import db_helper
from data_types import *
from config import *
from billing_client import BillingClient

logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.ReportComment_Req(web.input())
        resp = protocol.ReportComment_Resp()

        if req.userid == 0:
            task = TaskOfDevice()
            task.device_id = req.device_id
            task.task_id = Task.ID_COMMENT
            task.type = TaskType.T_COMMENT
            task.status = TaskStatus.S_DONE
            task.money = TASK_REWARD_COMMENT
            n = db_helper.insert_task_of_device(task)
        else:
            task = TaskOfUser()
            task.userid = req.userid
            task.device_id = req.device_id
            task.task_id = Task.ID_COMMENT
            task.type = TaskType.T_COMMENT
            task.status = TaskStatus.S_DONE
            task.money = TASK_REWARD_COMMENT
            n = db_helper.insert_task_of_user(task)

        if n > 0:
            #奖励0.1元
            BillingClient.instance().recharge(req.device_id, req.userid, TASK_REWARD_COMMENT, '好评旺财')

            resp.income = TASK_REWARD_COMMENT

        return resp.dump_json()
