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
        entry.name = '京东余额充值卡50元'
        entry.icon = ''
        entry.price = 4000
        entry.remain = db_helper.count_available_exchange_code_jingdong()
        entry.description = '兑换价格%d元,剩余%d张' %(entry.price/100,entry.remain)
        entry.is_most_cheap = 1
        entry.succeed_tip = '请及时充值，以防充值卡密码泄露。'
        resp.exchange_list.append(entry)

        entry = ExchangeEntry()
        entry.type = ExchangeType.T_ALIPAY
        entry.name = '提现到支付宝卡余额(即时到账)'
        entry.icon = ''
        entry.price = 3500
        entry.remain = 9999999
        entry.description = '提现面额 10元 30元 50元'
        entry.is_most_cheap = 0
        entry.succeed_tip = '提现将会在1天内到账，请留意短信通知及支付宝卡余额'
        resp.exchange_list.append(entry)

        entry = ExchangeEntry()
        entry.type = ExchangeType.T_PHONEPAY
        entry.name = '手机话费充值(即时到账)'
        entry.icon = ''
        entry.price = 3500
        entry.remain = 999999999
        entry.description = '充值面额 10元 30元 50元'
        entry.is_most_cheap = 0
        entry.succeed_tip = '提现将会在1天内到账，请留意短信通知及支付宝账户余额'
        resp.exchange_list.append(entry)

        entry = ExchangeEntry()
        entry.type = ExchangeType.T_UNDEFINED
        entry.name = '更多兑换方式敬请期待 ...'
        entry.icon = ''
        entry.price = 3500
        entry.remain = 999999999
        entry.description = ''
        entry.is_most_cheap = 0
        entry.succeed_tip = '提现将会在1天内到账，请留意短信通知及支付宝账户余额'
        resp.exchange_list.append(entry)

        return resp.dump_json()
