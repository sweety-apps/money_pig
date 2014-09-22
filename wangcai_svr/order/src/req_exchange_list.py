# -*- coding: utf-8 -*-
# 超值兑换列表

import web
import logging
import protocol
import db_helper
from data_types import *

logger = logging.getLogger()

class Handler:
    def GET(self):
        req  = protocol.ExchangeList_Req(web.input())
        resp = protocol.ExchangeList_Resp()

        entry = ExchangeEntry()
        entry.type = ExchangeType.T_JINGDONG
        entry.name = '50元京东礼品卡'
        entry.icon = 'http://getwangcai.com/images/jingdong.png'
        entry.price = 4500
        entry.remain = db_helper.count_available_exchange_code_jingdong()
        resp.exchange_list.append(entry)

        entry = ExchangeEntry()
        entry.type = ExchangeType.T_XLVIP   
        entry.name = '迅雷白金会员月卡'
        entry.icon = 'http://getwangcai.com/images/xlvip.png'
        entry.price = 800
        entry.remain = db_helper.count_available_exchange_code_xlvip()
        resp.exchange_list.append(entry)

        return resp.dump_json()
    
