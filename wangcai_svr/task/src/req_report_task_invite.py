# -*- coding: utf-8 -*-
# 邀请任务

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
        req = protocol.ReportInvite_Req(web.input())
        resp = protocol.ReportInvite_Resp()

        task = TaskInvite()
        task.userid = req.userid
        task.invitee = req.invitee
        task.invite_code = req.invite_code

        n = db_helper.insert_task_invite(task)
        if n == 0:
            #已经邀请过
            return resp.dump_json()

        task = TaskOfUser()
        task.userid = req.invitee
        task.device_id = ''
        task.task_id = Task.ID_INVITE
        task.type = TaskType.T_INVITE
        task.status = TaskStatus.S_DONE
        task.money = TASK_REWARD_INVITEE
        n = db_helper.insert_task_of_user(task)

        if n == 0:
            return resp.dump_json()

        #被邀请者奖励2元
        BillingClient.instance().recharge('', req.invitee, TASK_REWARD_INVITEE, '被邀请奖励2元')

#        n = db_helper.count_task_invite(req.userid)
#        if n <= TASK_INVITE_NUM_MAX:
#            #邀请者奖励1元
#            BillingClient.instance().recharge(req.device_id, req.userid, TASK_REWARD_INVITE, '邀请奖励1元')

#        resp.total_invite = n
        return resp.dump_json()


        

