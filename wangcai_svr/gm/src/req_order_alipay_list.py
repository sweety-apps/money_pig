# -*- coding: utf-8 -*-

import web
import json
import logging
import protocol

logger = logging.getLogger()

class Handler:
    def GET(self):
        req  = protocol.OrderAlipayList_Req()
        resp = protocol.OrderAlipayList_Resp()

        return resp.dump_json()
