# -*- coding: utf-8 -*-

import web
import logging
import protocol
from config import *
from utils import *

logger = logging.getLogger()

class Handler:
    def GET(self):
        req = protocol.TaskListReq(web.input(), web.cookies())
        resp = protocol.TaskListResp()

        #查设备任务
        url = 'http://' + TASK_BACKEND + '/list/task_of_device?device_id=' + req.device_id

        r = http_request(url)
        if r.has_key('rtn') and r['rtn'] == 0:
            task_map = dict([(task['id'], task) for task in r['task_list']])
        else:
            task_map = {}

        #已绑定,查帐号任务
        if req.userid != 0:
            url = 'http://' + TASK_BACKEND + '/list/task_of_user?userid=' + str(req.userid)
            r = http_request(url)
            if r.has_key('rtn') and r['rtn'] == 0:
                for task in r['task_list']:
                    if task['id'] in task_map:
                        if task_map[task['id']]['status'] != 0:
                            status = task_map[task['id']]['status']
                        elif task['status'] != 0:
                            status = task['status']
                        else:
                            status = 0
                        #相同id的任务进行合并
                        task_map[task['id']]['status'] = status
                    else:
                        task_map[task['id']] = task

        #屏蔽签到任务
        if 4 in task_map:
            del task_map[4]

        #为苹果审核屏蔽
        app = web.cookies().get('app', '')
        ver = web.cookies().get('ver', '')
        if app.lower() == 'wangcai' and ver in ['1.1', '1.2']:
            if 5 in task_map:
                del task_map[5]
            if 6 in task_map:
                del task_map[6]
            

        resp.task_list = sorted(task_map.values(), key=lambda x: x['id'])
        return resp.dump_json()


