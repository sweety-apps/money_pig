#!/bin/env python
# -*- coding: utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import web
import utils
import req_register
import req_bind_phone
import req_query_userid
import req_query_inviter
import req_user_info
import req_update_user_info
import req_update_inviter
import logging


urls = (
    '/register', req_register.Handler,
    '/bind_phone', req_bind_phone.Handler,
    '/userid', req_query_userid.Handler,
    '/inviter', req_query_inviter.Handler,
    '/user_info', req_user_info.Handler,
    '/update_user_info', req_update_user_info.Handler,
    '/update_inviter', req_update_inviter.Handler,
)

web.config.debug = True
#web.internalerror = web.debugerror

utils.init_logger('../log/account.log',logging.DEBUG)

app = web.application(urls, globals(), autoreload=False)

if __name__ == '__main__':
    app.run()
else:
    application = app.wsgifunc()


