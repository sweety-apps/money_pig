# -*- coding: utf-8 -*-
# 邀请任务

import web
import random
import logging
import protocol
import db_helper
from data_types import *
from billing_client import BillingClient

logger = logging.getLogger()


class CheckInAwardType:
    T_NONE = 0
    T_1MAO = 1
    T_5MAO = 2
    T_3YUAN = 3
    T_8YUAN = 4

class CheckInAward:
    def __init__(self, type, money, probability):
        self.type = type
        self.money = money
        self.probability = probability

    def desc(self):
        return 'check-in: ' + dict([(v, k) for k, v in CheckInAwardType.__dict__.items() if k.startswith('T_')])[self.type]


CHECKIN_AWARD_DEFINES = [
    CheckInAward(CheckInAwardType.T_NONE,  0,   0),
    CheckInAward(CheckInAwardType.T_1MAO,  10,  0.855),
    CheckInAward(CheckInAwardType.T_5MAO,  50,  0.14),
    CheckInAward(CheckInAwardType.T_3YUAN, 300, 0.004),
    CheckInAward(CheckInAwardType.T_8YUAN, 800, 0.001)
]


class Handler:
    def POST(self):
        req  = protocol.CheckIn_Req(web.input())
        resp = protocol.CheckIn_Resp()

        self.userid = req.userid
        self.device_id = req.device_id

        #是否已经签过到
        if self.already_checked_in():
            resp.rtn = 1
            return resp.dump_json()
        else:
            award = self.roll()
            #roll到了,给账户充值
            if award.money > 0:
                BillingClient.instance().recharge(req.device_id, req.userid, award.money, '抽奖赢得%.1f元' %(award.money/100.0))
            task = TaskCheckIn()
            task.userid = req.userid
            task.device_id = req.device_id
            task.money = award.money
            task.extra = award.desc()
            db_helper.insert_task_checkin(task)
            resp.award = award.type
            return resp.dump_json()

    def already_checked_in(self):
        if self.userid == 0:
            task = db_helper.query_task_checkin_by_device_id(self.device_id)
        else:
            task = db_helper.query_task_checkin_by_userid(self.userid)
        return task is not None

    def roll(self):
        x = random.uniform(0, 1)
        logger.debug('roll: %.3f' %x)
        n = 0.0
        for award in CHECKIN_AWARD_DEFINES:
            n += award.probability
            if x < n:
                break
        return award


if __name__ == '__main__':
    h = Handler()
    results = {}
    for i in xrange(0, 10000):
        award = h.roll()
        if award.type in results:
            results[award.type] += 1
        else:
            results[award.type] = 1
    print sorted([(k, '%.4f' %(v/10000.0)) for k, v in results.items()])
            

