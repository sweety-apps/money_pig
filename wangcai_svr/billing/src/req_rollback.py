# -*- coding: utf-8 -*-
# 回滚冻结请求

import web
import logging
import protocol
import db_helper
from data_types import *

logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.Rollback_Req(web.input())
        resp = protocol.Rollback_Resp()

        #userid不能为0
        if req.userid == 0:
            resp.rtn = BillingError.E_INVALID_ACCOUNT
        else:
            resp.rtn = db_helper.do_rollback(req.userid, req.device_id, req.serial_num)       

        return resp.dump_json()

