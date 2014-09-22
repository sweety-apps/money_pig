#!/bin/env python
# -*- coding: utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import web
import logging
from logging.handlers import RotatingFileHandler

import req_activate_account
import req_query_balance
import req_recharge
import req_freeze
import req_commit
import req_rollback
import req_query_history
import req_shared_income


def init_logger(path, level=logging.NOTSET, maxBytes=50*1024*1024, backupCount=20):
    logger = logging.getLogger()
    logger.setLevel(level)
    file_handler = RotatingFileHandler(path, maxBytes=maxBytes, backupCount=backupCount)
    file_handler.setFormatter(logging.Formatter("[%(asctime)s] [%(levelname)s] %(message)s", "%Y%m%d %H:%M:%S"))
    logger.addHandler(file_handler)


urls = (
    '/activate_account', req_activate_account.Handler,
    '/query_balance', req_query_balance.Handler,
    '/recharge', req_recharge.Handler,
    '/freeze', req_freeze.Handler,
    '/commit', req_commit.Handler,
    '/rollback', req_rollback.Handler,
    '/query_history', req_query_history.Handler,
    '/shared_income', req_shared_income.Handler
)


init_logger("../log/billing.log",logging.DEBUG)

app = web.application(urls, globals(), autoreload = False)

if __name__ == '__main__':
    app.run()
else:
    application = app.wsgifunc()


