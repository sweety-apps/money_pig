# -*- coding: utf-8 -*-

import web
import logging
import protocol
import db_helper

logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.ReportNewbie_Req(web.input())
        resp = protocol.ReportNewbie_Resp()
