# -*- coding: utf-8 -*-

import web
import json
import urllib
import logging
import protocol
from config import *
from utils import *

logger = logging.getLogger()

class Handler:
    def GET(self):
        req  = protocol.OrderDetailReq(web.input(), web.cookies())
        resp = protocol.OrderDetailResp()

        #userid不能为0
        if req.userid == 0:
            resp.res = 1
            return resp.dump_json()

        params = {
            'userid': req.userid,
            'order_id': req.order_id
        }

        url = 'http://' + ORDER_BACKEND + '/order_detail?' + urllib.urlencode(params)

        r = http_request(url)

        if r['rtn'] != 0:
            resp.res = r['rtn']
        else:
            resp.type = r['type']
            resp.status = r['status']
            resp.money = r['money']
            resp.create_time = r['create_time']
            resp.confirm_time = r['confirm_time']
            resp.complete_time = r['operate_time']
            resp.extra = r['extra']

        return resp.dump_json()
