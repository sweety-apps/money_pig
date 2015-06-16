# -*- coding: utf-8 -*-
# 查询任务详情

import web
import logging
import protocol
import db_helper
from data_types import *

logger = logging.getLogger()

class Handler:
    def GET(self):
        req = protocol.GetTaskDetail_Req(web.input())
        resp = protocol.GetTaskDetail_Resp()

        task = db_helper.query_task_base(req.task_id)
        if task is None:
            resp.rtn = 1
            return resp.dump_json()

        if task.type == TaskType.T_APP:
            resp.task = self.task_detail_app(req.task_id)
        else:
            resp.task = self.task_detail_builtin(req.task_id)

        if resp.task is None:
            resp.rtn = 1

        return resp.dump_json()


    def task_detail_app(self, task_id):
        return db_helper.query_task_app(task_id)

    def task_detail_builtin(self, task_id):
        return Task()


