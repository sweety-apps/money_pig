# -*- coding: utf-8 -*-
# 欧飞接口

import json
import urllib
import urllib2
import hashlib
import logging
import socket
from config import *

try:
    import xml.etree.cElementTree as ET
except:
    import xml.etree.ElementTree as ET

logger = logging.getLogger('ofpay_client')

class OfpayClient:

    s_instance = None

    @classmethod
    def instance(cls):
        if cls.s_instance is None:
            cls.s_instance = cls()
        return cls.s_instance

    def __init__(self):
        pass

    def telcheck(self, phone_num, amount):
        url = OFPAY_HOST + '/telcheck.do'
        data = {'phoneno':phone_num, 'price':amount, 'userid':OFPAY_USERID}
        resp = self.make_request(url, 'GET', data)
        if resp['rtn'] != 0:
            return resp['rtn'], 'error'
        else:
            print resp['content'].decode('gbk').encode('utf-8')
            a = resp['content'].decode('gbk').encode('utf-8').split('#')
            if int(a[0]) == 1:
                return 0, a[2]
            else:
                return 1, a[2]

    def calc_md5str(self, data):
        '''包体 = userid + userpws + cardid + cardnum + sporder_id + sporder_time + game_userid
        1: 对: “包体+KeyStr” 这个串进行md5 的32位值. 结果大写
        2: KeyStr 默认为 OFCARD, 实际上线时可以修改。
        3: KeyStr 不在接口间进行传送。'''

        params = [
            data['userid'], data['userpws'],
            data['cardid'], str(data['cardnum']), 
            data['sporder_id'], data['sporder_time'],
            data['game_userid'],
            'OFCARD'
        ]
        return hashlib.md5(''.join(params)).hexdigest().upper()


    def charge(self, phone_num, amount, order_id, order_time):
        url = OFPAY_HOST + '/onlineorder.do'
        data = {
            'userid': OFPAY_USERID,
            'userpws': OFPAY_PASSWD,
            'cardid': '140101',  #快充
            'cardnum': amount,
            'mctype': 0,
            'sporder_id': order_id, 
            'sporder_time': order_time,
            'game_userid': phone_num,
            'version': '6.0'
        }
        data['md5_str'] = self.calc_md5str(data)
        resp = self.make_request(url, 'GET', data)
        if resp['rtn'] != 0:
            return resp['rtn'], 'error'
        else:
            try:
#            print resp['content']
                content_tmp = '\r\n'.join([line for line in resp['content'].split('\r\n') if not line.startswith('<?xml')])
                content_utf8 = content_tmp.decode('gbk').encode('utf-8')
                print content_utf8
                root = ET.fromstring(content_utf8)
                retcode = int(root.find('retcode').text)
                err_msg = root.find('err_msg').text
                if retcode == 1:
                    return 0, ''
                else:
                    logger.error('charge failed! retcode:%d, err:%s' %(retcode, err_msg))
                    print err_msg
                    return retcode, err_msg
            except:
                return 1, 'xml parse error'


    def alipay(self, alipay_account, amount, order_id, order_time):
        url = OFPAY_HOST + '/onlineorder.do'
        data = {
            'userid': OFPAY_USERID,
            'userpws': OFPAY_PASSWD,
            'cardid': '6102100',  #支付宝充值
            'cardnum': 1, #固定值
            'sporder_id': order_id, 
            'sporder_time': order_time,
            'game_userid': alipay_account,
            'actprice': '%.1f' %amount,
            'version': '6.0'
        }
        data['md5_str'] = self.calc_md5str(data)
        resp = self.make_request(url, 'GET', data)
        if resp['rtn'] != 0:
            return resp['rtn'], 'error'
        else:
            try:
                content_tmp = '\r\n'.join([line for line in resp['content'].split('\r\n') if not line.startswith('<?xml')])
                content_utf8 = content_tmp.decode('gbk').encode('utf-8')
                print content_utf8
                root = ET.fromstring(content_utf8)
                retcode = int(root.find('retcode').text)
                err_msg = root.find('err_msg').text
                if retcode == 1:
                    return 0, ''
                else:
                    logger.error('transfer failed! retcode:%d, err:%s' %(retcode, err_msg))
                    print err_msg
                    return retcode, err_msg
            except:
                return 1, 'xml parse error'


    def make_request(self, url, method, data, timeout = 3):
        logger.debug('url: %s, data: %s' %(url, json.dumps(data, ensure_ascii=False)))
        if method.upper() == 'POST':
            req = urllib2.Request(url, urllib.urlencode(data))
        else:
            req = urllib2.Request(url + '?' + urllib.urlencode(data))

        try:
            resp = urllib2.urlopen(req, timeout = timeout).read()
#            resp = resp.decode('gbk').encode('utf-8')
            logger.debug('resp: %s' %resp.decode('gbk').encode('utf-8'))
            return {'rtn': 0, 'content': resp}
        except urllib2.HTTPError, e:
            return {'rtn': -e.code}
        except urllib2.URLError, e:
            if isinstance(e.reason, socket.timeout):
                return {'rtn': -1}
            else:
                return {'rtn': -2}


if __name__ == '__main__':
#    rtn, msg = OfpayClient.instance().telcheck('13632512376', 5)
#    rtn, msg = OfpayClient.instance().charge('13655831069', 10, '201401231305080000000009e6', '2014-01-23 13:05:08')
#    rtn = OfpayClient.instance().alipay('zxp0213051@163.com', 20.0, '201401231401200000000009em', '2014-01-23 14:01:20')
    print rtn, msg
