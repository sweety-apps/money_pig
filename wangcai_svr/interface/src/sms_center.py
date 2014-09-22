# -*- coding: utf-8 -*-

import web
import urllib
import urllib2
import uuid
import hashlib
import random
import logging
#import MySQLdb
import pymysql
MySQLdb = pymysql


try:
    import xml.etree.cElementTree as ET
except:
    import xml.etree.ElementTree as ET

from config import *
from utils import *


logger = logging.getLogger('sms_center')

class SMSAction:
    BIND_PHONE = 1
    TRANSFER_MONEY = 2

class SMSStatus:
    INIT = 0
    SMS_SUCC = 1
    SMS_FAIL = 2
    SMS_CONFIRMED = 3


class SMSCenter:

    s_instance = None

    @classmethod
    def instance(cls):
        if cls.s_instance is None:
            cls.s_instance = cls()
        return cls.s_instance


    def __init__(self):
        self._conn = MySQLdb.connect(host=MYSQL_HOST, user=MYSQL_USER, passwd=MYSQL_PASSWD, db=MYSQL_DB, charset='utf8')
        self._conn.autocommit(True)

    def gen_sms_code(self, code_len=5):
        code = ''
        for each in range(0, code_len):
            code += str(random.randint(0, 9))
        return code
            
    def gen_token(self):
        return hashlib.md5(str(uuid.uuid4())).hexdigest()

    def send_sms_code(self, phone_num, sms_code):
        content = SMS_TEMPLATE %sms_code
        return self.__send_sms(phone_num, content)

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
        except:
            logger.error('got exception')

        return False


    def create_sms_task(self, phone_num, action, data):
        token = self.gen_token()
        code = self.gen_sms_code()
        stmt = "INSERT INTO sms_center \
                    SET token = '%s', phone_num = '%s', sms_code = '%s', \
                        action = %d, data = '%s', insert_time = NOW()" \
                        % (token, MySQLdb.escape_string(phone_num), code, action, MySQLdb.escape_string(data))
        self._conn.ping(True)
        cur = self._conn.cursor()
        cur.execute(stmt)
        self._conn.commit()
        return (token, code)


    def update_sms_code(self, token, sms_code):
        stmt = "UPDATE sms_center SET sms_code = '%s'" %sms_code
        self._conn.ping(True)
        cur = self._conn.cursor()
        cur.execute(stmt)
        self._conn.commit()
        return (token, sms_code)


    def find_item(self, token):
        stmt = "SELECT *, UNIX_TIMESTAMP(ts) as u_ts FROM sms_center WHERE token = '%s'" %MySQLdb.escape_string(token)
        self._conn.ping(True)
        cur = self._conn.cursor(MySQLdb.cursors.DictCursor)
        n = cur.execute(stmt)
        if n == 0:
            return None
        else:
            res = cur.fetchone()
            return res


    def check_sms(self, token, sms_code):
        item = self.find_item(token)
        if item is None:
            return None
        else:
            if cur_timestamp() - int(item['u_ts']) > SMS_EXPIRES:
                logger.info('sms timeout!!')
                return None
            elif sms_code.upper() != item['sms_code'].upper():
                logger.debug('sms mismatch!!')
                return None
            else:
                self.update_status(token, SMSStatus.SMS_CONFIRMED)
                return (int(item['action']), item['data'])
        

    def update_status(self, token, status):
        stmt = "UPDATE sms_center SET status = %d WHERE token = '%s'" %(status, MySQLdb.escape_string(token))
        self._conn.ping(True)
        cur = self._conn.cursor()
        cur.execute(stmt)
        self._conn.commit()


    def notify_exchange_code(self, phone_num, exchange_desc, exchange_code):
        content = SMS_TPL_EXCHANGE_CODE % (exchange_desc, exchange_code)
        return self.__send_sms(phone_num, content)
        
    def confirm_order_alipay(self, phone_num, amount):
        content = SMS_TPL_ALIPAY % amount
        return self.__send_sms(phone_num, content)

    def confirm_order_phone_charge(self, phone_num, amount):
        content = SMS_TPL_PHONE_CHARGE % amount
        return self.__send_sms(phone_num, content)



