# -*- coding: utf-8 -*-

import web
import json
import logging
import db_helper
from data_types import *

class Handler:
    def POST(self):
        params = web.input()
        device_id = params.device_id
        userid = int(params.userid)
        invite_code = params.invite_code

        #通过invite_code查到inviter的userid
        inviter = db_helper.query_userid_by_invite_code(invite_code)
        if inviter is None:
            return json.dumps({'rtn': 1})
        elif inviter == userid:
            return json.dumps({'rtn': 2})

        #更新inviter字段
        db_helper.update_inviter(userid, inviter, invite_code)

        return json.dumps({'rtn': 0, 'inviter': inviter})

