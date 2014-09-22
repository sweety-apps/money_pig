# -*- coding: utf-8 -*-

import web
import logging
import protocol
import db_helper

logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.AppDownload_Req(web.input())
        resp = protocol.AppDownload_Resp()

        db_helper.insert_task_app_download(req.device_id, req.userid, req.appid)
        return resp.dump_json()


        

