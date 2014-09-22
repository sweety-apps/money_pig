# -*- coding: utf-8 -*-

import web
import json
import urllib
from config import *
from utils import *
from session_manager import SessionManager


class Handler:
    def GET(self):
        params = web.input()

        if not SessionManager.instance().check_session(params.session_id, params.device_id, int(params.userid)):
            resp = {'res':401, 'msg':'登陆态异常'}
            return json.dumps(resp, ensure_ascii=False)

        data = {'device_id': params.device_id, 'userid': int(params.userid)}
        url = 'http://' + ACCOUNT_BACKEND + '/user_info?' + urllib.urlencode(data)

        r = http_request(url)
        if r.has_key('rtn') and r['rtn'] == 0:
            resp = {
                'res': 0,
                'msg': '',
                'userid': int(r['userid']),
                'phone': r['phone_num'],
#                'nickname': r['nickname'],
                'sex': int(r['sex']),
                'age': int(r['age']),
                'interest': r['interest']
            }
        else:
            resp = {'res': 1, 'msg': 'error'}

        return json.dumps(resp)

