# -*- coding: utf-8 -*-

import web
import logging
import protocol
from config import *
from utils import *

logger = logging.getLogger()

class Handler:
    def GET(self):
        req = protocol.TaskDetailReq(web.input(), web.cookies())
        resp = protocol.TaskDetailResp()

        params = {
            'device_id': req.device_id,
            'userid': req.userid,
            'task_id': req.task_id
        }

        url = 'http://' + TASK_BACKEND + '/task_detail?' + urllib.urlencode(params)

        r = http_request(url)
        if r.has_key('rtn') and r['rtn'] == 0:
            resp.task = r['task']
            return resp.dump_json()

        return resp.dump_json()

