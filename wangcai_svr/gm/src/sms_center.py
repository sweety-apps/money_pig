# -*- coding: utf-8 -*-

import web
import urllib
import urllib2
import uuid
import hashlib
import random
import logging
from config import *

try:
    import xml.etree.cElementTree as ET
except:
    import xml.etree.ElementTree as ET


logger = logging.getLogger('sms_center')

class SMSCenter:

    s_instance = None

    @classmethod
    def instance(cls):
        if cls.s_instance is None:
            cls.s_instance = cls()
        return cls.s_instance


    def __init__(self):
        pass

        
    def notify_order_alipay(self, phone_num, order_id, amount):
#        content = SMS_TPL_ALIPAY % amount
        content = SMS_TPL_ALIPAY % order_id
        return self.__send_sms(phone_num, content)

#    def confirm_order_phone_charge(self, phone_num, amount):
#        content = SMS_TPL_PHONE_CHARGE % amount
#        return self.__send_sms(phone_num, content)


    def __send_sms(self, phone_num, sms_content):
        params = {
            'method': 'Submit',
            'account': SMS_USER,
            'password': SMS_PASSWD,
            'mobile': phone_num,
            'content': sms_content
        }

        logger.debug(SMS_API+'?'+urllib.urlencode(params))

        try:
            resp = urllib2.urlopen(SMS_API+'?'+urllib.urlencode(params))
            root = ET.fromstring(resp.read())
            assert root.tag == str(ET.QName(SMS_XMLNS, 'SubmitResult'))
            code = int(root.find(str(ET.QName(SMS_XMLNS, 'code'))).text)
            if (code == 2):
                logger.debug('send sms successfully')
                return True
            else:
                msg = root.find(str(ET.QName(SMS_XMLNS, 'msg'))).text
                logger.error('send sms failed!! code:%d, msg:%s' %(code, msg))
        except urllib2.URLError, e:
            logger.error('URLError = ' + str(e.reason))
        except urllib2.HTTPError, e:
            logger.error('HTTPError = ' + str(e.code))
#        except:
#            logger.error('got exception')
        return False



