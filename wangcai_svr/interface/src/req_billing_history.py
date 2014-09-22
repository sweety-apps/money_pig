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
        req  = protocol.BillingHistoryReq(web.input(), web.cookies())
        resp = protocol.BillingHistoryResp()

        params = {
            'userid': req.userid,
            'device_id': req.device_id,
            'offset': req.offset,
            'num': req.num
        }

        url = 'http://' + BILLING_BACKEND + '/query_history?' + urllib.urlencode(params)

        r = http_request(url)
        if r['rtn'] == 0:
            resp.history = r['history']
        else:
            resp.res = r['rtn']

        return resp.dump_json()
