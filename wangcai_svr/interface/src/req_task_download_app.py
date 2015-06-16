# -*- coding: utf-8 -*-

import web
import logging
import protocol
from config import *
from utils import *

logger = logging.getLogger()

class Handler:
    def GET(self):
        req  = protocol.DownloadAppReq(web.input(), web.cookies())
        resp = protocol.DownloadAppResp()

        data = {
            'userid': req.userid,
            'device_id': req.device_id,
            'appid': req.appid
        }

        url = 'http://' + TASK_BACKEND + '/report_app_download'
        http_request(url, data)

        return resp.dump_json()

