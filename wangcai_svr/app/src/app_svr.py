#!/bin/env python
# -*- coding: utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import web
import logging
from logging.handlers import RotatingFileHandler

import req_callback
import req_youmi


def init_logger(path, level=logging.NOTSET, maxBytes=50*1024*1024, backupCount=20):
    logger = logging.getLogger()
    logger.setLevel(level)
    file_handler = RotatingFileHandler(path, maxBytes=maxBytes, backupCount=backupCount)
    file_handler.setFormatter(logging.Formatter("[%(asctime)s] [%(levelname)s] %(message)s", "%Y%m%d %H:%M:%S"))
    logger.addHandler(file_handler)


urls = (
    '/callback', req_callback.Handler,
    '/youmi', req_youmi.Handler
)

init_logger("../log/app.log")

web.config.debug = False
app = web.application(urls, globals(), autoreload = False)

if __name__ == '__main__':
    app.run()
else:
    application = app.wsgifunc()



