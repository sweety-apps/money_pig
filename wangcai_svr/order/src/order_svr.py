#!/bin/env python
# -*- coding: utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import web
import logging
from logging.handlers import RotatingFileHandler

import req_alipay_transfer
import req_phone_payment
import req_exchange_list
import req_exchange_code
import req_order_detail
import req_order_list
import req_order_list_alipay_transfer
import req_order_list_phone_payment
import req_confirm_alipay_transfer
import req_confirm_phone_payment


def init_logger(path, level=logging.NOTSET, maxBytes=50*1024*1024, backupCount=20):
    logger = logging.getLogger()
    logger.setLevel(level)
    file_handler = RotatingFileHandler(path, maxBytes=maxBytes, backupCount=backupCount)
    file_handler.setFormatter(logging.Formatter("[%(asctime)s] [%(levelname)s] %(message)s", "%Y%m%d %H:%M:%S"))
    logger.addHandler(file_handler)


urls = (
    '/alipay_transfer', req_alipay_transfer.Handler,
    '/phone_payment', req_phone_payment.Handler,
    '/exchange_list', req_exchange_list.Handler,
    '/exchange_code', req_exchange_code.Handler,
    '/order_detail', req_order_detail.Handler,
    '/order_list', req_order_list.Handler,
    '/order_list_alipay_transfer', req_order_list_alipay_transfer.Handler,
    '/order_list_phone_payment', req_order_list_phone_payment.Handler,
    '/confirm_alipay_transfer', req_confirm_alipay_transfer.Handler,
    '/confirm_phone_payment', req_confirm_phone_payment.Handler,
)


init_logger("../log/order.log")

app = web.application(urls, globals(), autoreload = False)

if __name__ == '__main__':
    app.run()
else:
    application = app.wsgifunc()


