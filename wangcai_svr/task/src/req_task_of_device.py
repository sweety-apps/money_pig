# -*- coding: utf-8 -*-

import web
import logging
import protocol
import db_helper
from data_types import *


logger = logging.getLogger()

class Handler:
    def GET(self):
        req = protocol.ListTaskOfDevice_Req(web.input())
        resp = protocol.ListTaskOfDevice_Resp()

        task_list = db_helper.select_builtin_task()
        if task_list is None or len(task_list) == 0:
            logger.error('builtin task is EMPTY!!')
            return resp.dump_json()

        task_map = dict([(task.id, task) for task in task_list])

        #安装旺财,默认已完成
        if Task.ID_NEWBIE in task_map:
            task_map[Task.ID_NEWBIE].status = TaskStatus.S_DONE

        #检查签到任务状态
        if Task.ID_CHECKIN in task_map:
            task = db_helper.query_task_checkin_by_device_id(req.device_id)
            if task is not None:
                task_map[Task.ID_CHECKIN].status = TaskStatus.S_DONE

        #查询已完成任务
        task_done = db_helper.select_task_of_device(req.device_id)
        task_map_done = dict([(task.task_id, task) for task in task_done or []])

        #处理用户信息等任务状态
        if Task.ID_INFO in task_map:
            if Task.ID_INFO in task_map_done:
                task_map[Task.ID_INFO].status = TaskStatus.S_DONE

        #处理评论旺财任务
        if Task.ID_COMMENT in task_map:
            if Task.ID_COMMENT in task_map_done:
                task_map[Task.ID_COMMENT].status = TaskStatus.S_DONE

        resp.task_list = task_map.values()

        #检查应用安装任务
        #1.获取线上厂商应用列表
        #2.分别检查是否已完成
        #3.返回结果数据
        task_list = db_helper.select_app_task()
        if task_list is None or len(task_list) == 0:
            pass
        else:
            for each in task_list:
                if each.id in task_map_done:
                    each.status = TaskStatus.S_DONE
                resp.task_list.append(each)
                
        return resp.dump_json()

