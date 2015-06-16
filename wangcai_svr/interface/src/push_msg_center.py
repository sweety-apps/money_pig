# -*- coding: utf-8 -*-

import web
import urllib
import urllib2
import uuid
import hashlib
import random
import logging
import base64
import cookielib
#import MySQLdb
import pymysql
MySQLdb = pymysql

from config import *
from utils import *

logger = logging.getLogger('push_msg_center')

class PushMsgCenter:

    s_instance = None

    @classmethod
    def instance(cls):
        if cls.s_instance is None:
            cls.s_instance = cls()
        return cls.s_instance

    def send_push_msg(self, deviceid, push_content):
        params = {
            'platform': 'all',
            'audience' : {
                'alias' : [deviceid]
            },
            'notification' : {
                'alert' : push_content,
                'android' : {},
                'ios' : {}
            }
        }

        req = urllib2.Request(JPUSH_V3_API)

        auth = ' Basic ' + JPUSH_AUTH_BASIC_VALUE
        req.add_header('Authorization', auth)

        req.add_header('Content-Type','application/json')

        req.add_header('User-Agent','jpush-api-python-client')

        params_json = json.dumps(params)
        req.add_data(params_json)

        print req.get_method()
        print req.header_items()
        print(JPUSH_V3_API+'\n json = \n'+params_json)
        logger.debug(JPUSH_V3_API+'\n json = \n'+params_json)

        try:
            cj = cookielib.CookieJar()
            opener = urllib2.build_opener(urllib2.HTTPCookieProcessor(cj))
            resp = opener.open(req)
            resp_data = resp.read()
            logger.debug(resp_data)
            return True
        except urllib2.URLError, e:
            print str(e)
            logger.error('URLError = ' + str(e.reason))
        except urllib2.HTTPError, e:
            logger.error('HTTPError = ' + str(e.code))
        except:
            logger.error('got exception')

        return False


if __name__ == '__main__':
    PushMsgCenter.instance().send_push_msg('c7bf970c36e050070cf80399a95dede8','test push')