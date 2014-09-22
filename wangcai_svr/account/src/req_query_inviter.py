# -*- coding: utf-8 -*-

import web
import json
import hashlib
import logging
import db_helper


logger = logging.getLogger()

class Handler:
    def init(self):
        params = web.input()
        self._userid = int(params.userid)

    def GET(self):
        self.init()
        
        if self._userid == 0:
            resp = {'rtn': 1}
        else:
            user = db_helper.query_user_info(self._userid)           
            if user is None or user.inviter_id == 0:
                resp = {'rtn': 2}
            else:
                resp = {'rtn': 0, 'inviter': user.inviter_id}

        return json.dumps(resp)
                


