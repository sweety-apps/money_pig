# -*- coding: utf-8 -*-

MYSQL_HOST = 'localhost'
MYSQL_USER = 'root'
MYSQL_PASSWD = ''
MYSQL_DB = 'wangcai_order'

ACCOUNT_BACKEND = 'http://127.0.0.1:15281'
BILLING_BACKEND = 'http://127.0.0.1:15283'
ORDER_BACKEND = 'http://127.0.0.1:15284'

OFPAY_HOST = 'http://api2.ofpay.com'
OFPAY_USERID = 'A917726'
OFPAY_PASSWD = 'fbe4b0e5833713f6a5e91f49a0faf241'

SMS_API = 'http://106.ihuyi.com/webservice/sms.php'
SMS_USER = 'cf_ksd'
SMS_PASSWD = '1528studioihuyi'
SMS_XMLNS = 'http://106.ihuyi.com/'

#SMS_TPL_ALIPAY = '您的支付宝提现%d元订单已转账，请浏览支付宝账号查收，感谢您的耐心等待。'
SMS_TPL_ALIPAY = '您的支付宝元订单%s已转账。请在支付宝-账户资产-账户收支明细中查询到帐情况，明细为“支付宝卡充值”。'

