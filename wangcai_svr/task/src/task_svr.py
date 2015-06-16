#!/bin/env python
# -*- coding: utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import web
import logging
from logging.handlers import RotatingFileHandler

import req_task_of_device
import req_task_of_user
import req_task_detail
import req_report_task_invite
import req_report_task_user_info
import req_report_task_comment
import req_report_app_download
import req_report_domob_point
import req_report_youmi_point
import req_report_task_offerwall
import req_process_app_callback
import req_process_task_checkin


def init_logger(path, level=logging.NOTSET, maxBytes=50*1024*1024, backupCount=20):
    logger = logging.getLogger()
    logger.setLevel(level)
    file_handler = RotatingFileHandler(path, maxBytes=maxBytes, backupCount=backupCount)
    file_handler.setFormatter(logging.Formatter("[%(asctime)s] [%(levelname)s] %(message)s", "%Y%m%d %H:%M:%S"))
    logger.addHandler(file_handler)


urls = (
    '/list/task_of_device', req_task_of_device.Handler,
    '/list/task_of_user', req_task_of_user.Handler,
    '/task_detail', req_task_detail.Handler,
    '/report_invite', req_report_task_invite.Handler,
    '/report_user_info', req_report_task_user_info.Handler,
    '/report_comment', req_report_task_comment.Handler,
    '/report_app_download', req_report_app_download.Handler,
    '/report_domob_point', req_report_domob_point.Handler,
    '/report_youmi_point', req_report_youmi_point.Handler,
    '/report_task_offerwall', req_report_task_offerwall.Handler,
    '/app_callback', req_process_app_callback.Handler,
    '/check-in', req_process_task_checkin.Handler,
)


init_logger("../log/task.log",logging.DEBUG)

app = web.application(urls, globals(), autoreload = False)

if __name__ == '__main__':
    app.run()
else:
    application = app.wsgifunc()

