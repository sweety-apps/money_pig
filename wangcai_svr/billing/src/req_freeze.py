# -*- coding: utf-8 -*-
# 冻结一定金额

import web
import logging
import protocol
import db_helper
from data_types import *


logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.Freeze_Req(web.input())
        resp = protocol.Freeze_Resp()

        #userid不能为0
        if req.userid == 0:
            resp.rtn = BillingError.E_INVALID_ACCOUNT
        else:
            result = db_helper.freeze_money(req.userid, req.device_id, req.money, req.remark)
            if isinstance(result, int):
                #freeze失败
                logger.error('freeze money failed!! err:%d, errmsg:%s' %(result, BillingError.strerror(result)))
                resp.rtn = result
            else:
                #freeze成功
                logger.info('freeze money succeed, userid:%d, money:%d' %(req.userid, req.money))
                resp.serial_num = result

        return resp.dump_json()


