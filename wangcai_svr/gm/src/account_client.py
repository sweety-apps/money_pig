# -*- coding: utf-8 -*-

import json
import urllib
import urllib2
import logging
from config import *

logger = logging.getLogger('account_client')

class AccountClient:

    s_instance = None

    @classmethod
    def instance(cls):
        if cls.s_instance is None:
            cls.s_instance = cls()
        return cls.s_instance

    def __init__(self):
        pass

    def user_info(self, userid):
        url = ACCOUNT_BACKEND + '/user_info'
        r = self.make_request(url, 'GET', {'userid':userid, 'device_id':''})
        if r['rtn'] != 0:
            logger.error('get user_info failed! rtn:%d' %r['rtn'])
            return None
        else:
            return {
                'userid': r['userid'],
                'phone_num': r['phone_num'],
                'invite_code': r['invite_code']
            }

    def make_request(self, url, method, data, timeout = 3):
        logger.debug('url: %s, data: %s' %(url, json.dumps(data, ensure_ascii=False)))
        if method == 'GET':
            req = urllib2.Request(url + '?' + urllib.urlencode(data))
        else:
            req = urllib2.Request(url, urllib.urlencode(data))

        try:
            resp = urllib2.urlopen(req, timeout = timeout).read()
            logger.debug('resp: %s' %resp)
            return json.loads(resp)
        except urllib2.HTTPError, e:
            return {'rtn': -e.code}
        except urllib2.URLError, e:
            if isinstance(e.reason, socket.timeout):
                return {'rtn': -1}
            else:
                return {'rtn': -2}


if __name__ == '__main__':
    u = AccountClient.instance().user_info(10000, '')
    print u

