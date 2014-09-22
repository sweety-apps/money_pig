#!/bin/env python
# -*- coding: utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import web
import utils
import req_register
import req_account_info
import req_update_user_info
import req_update_inviter
import req_bind_phone
import req_bind_phone_confirm
import req_resend_sms_code
import req_billing_history
import req_task_list
import req_task_detail
import req_task_checkin
import req_task_comment
import req_task_download_app
import req_task_domob
import req_task_offerwall
import req_order_alipay
import req_order_phone_pay
import req_order_exchange_code
import req_order_exchange_list
import req_order_detail
import logging


urls = (
    '/0/register', req_register.Handler,
    '/0/account/info', req_account_info.Handler,
    '/0/account/update_user_info', req_update_user_info.Handler,
    '/0/account/update_inviter', req_update_inviter.Handler,
    '/0/account/bind_phone', req_bind_phone.Handler,
    '/0/account/bind_phone_confirm', req_bind_phone_confirm.Handler,
    '/0/account/billing_history', req_billing_history.Handler,
    '/0/sms/resend_sms_code', req_resend_sms_code.Handler,
    '/0/task/list', req_task_list.Handler,
    '/0/task/detail', req_task_detail.Handler,
    '/0/task/check-in', req_task_checkin.Handler,
    '/0/task/comment', req_task_comment.Handler,
    '/0/task/download_app', req_task_download_app.Handler,
    '/0/task/domob',  req_task_domob.Handler,
    '/0/task/offerwall',  req_task_offerwall.Handler,
    '/0/order/alipay', req_order_alipay.Handler,
    '/0/order/phone_pay', req_order_phone_pay.Handler,
    '/0/order/exchange_code', req_order_exchange_code.Handler,
    '/0/order/exchange_list', req_order_exchange_list.Handler,
    '/0/order/detail', req_order_detail.Handler
)

web.config.debug = True
#web.internalerror = web.debugerror

utils.init_logger("../log/interface.log",logging.DEBUG)

app = web.application(urls, globals(), autoreload=False)

if __name__ == '__main__':
    app.run()
else:
    application = app.wsgifunc()

