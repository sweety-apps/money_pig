# -*- coding: utf-8 -*-


ACCOUNT_BACKEND = '127.0.0.1:15281'
TASK_BACKEND = '127.0.0.1:15282'
BILLING_BACKEND = '127.0.0.1:15283'
ORDER_BACKEND = '127.0.0.1:15284'

MYSQL_HOST = 'localhost'
MYSQL_USER = 'root'
MYSQL_PASSWD = ''
MYSQL_DB = 'wangcai'

SESSION_MEMCACHE = ['127.0.0.1:11211']
SESSION_PREFIX = 'ss_'
SESSION_LIVETIME = 3600*2

SMS_API = 'http://106.ihuyi.com/webservice/sms.php'
SMS_USER = 'cf_monkeybad'
SMS_PASSWD = 'ff147258'
SMS_TEMPLATE = '您的验证码是：【%s】。请不要把验证码泄露给其他人。如非本人操作，可不用理会！'
SMS_XMLNS = 'http://106.ihuyi.com/'
SMS_EXPIRES = 180   #180s

SMS_TPL_ALIPAY = '您的支付宝提现%d元订单已收到，工作人员会在1个工作日内转账，请留意手机短信通知并耐心等待，谢谢。'
SMS_TPL_PHONE_CHARGE = '您的手机充值%d元订单已收到，工作人员会在1个工作日内充值，请留意运营商短信提醒。'
SMS_TPL_EXCHANGE_CODE = '你已成功兑换%s，请牢记激活码【%s】。如遇使用问题请查看赚钱小猪使用帮助或联系客服。'

SWITCH_NO_WITHDRAW = 0

SWITCH_SERVER_DOWN = 0
SWITCH_SERVER_DOWN_MSG = '内测说明$为了保证服务质量，旺财限制了内测用户总量，很遗憾当前名额已满，请隔天重试或等待旺财公测版本。'

SWITCH_SERVER_TIPS = 0
SWITCH_SERVER_TIPS_CONTENT = '通知$春节期间旺财正常测试运行，每日一定限额内自动快速到帐。感谢大家内测期间协助旺财发现并改进问题，我们会努力为各位旺友提供更好的服务和体验。旺财团队祝愿广大用户春节快乐，新年旺财！（另：QQ客服春节休假，咨询问题请使用软件内置客服系统）'


#BILLING_MQ_HOST = 'localhost'
#BILLING_MQ_PORT = 6379
#BILLING_MQ_CHANNEL = 'billing'

TASK_MQ_HOST = 'localhost'
TASK_MQ_PORT = 6379
TASK_MQ_CHANNEL = 'wangcai:task'

AES_KEY = 'cd421509726b38a2ffd2997caed6dab9'

