# -*- coding: utf-8 -*-

import web
import json
import re
import urllib
import urllib2
import logging

ACCOUNT_BACKEND = 'http://127.0.0.1:15281'
TASK_BACKEND = 'http://127.0.0.1:15282'

logger = logging.getLogger()

class Handler:
    def __init__(self):
        self.appid = ''
        self.idfa = ''
        self.mac = ''
        self.re_appid = re.compile('\d+$')
        self.re_idfa = re.compile('[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}$')
        self.re_mac = re.compile('[0-9A-F]{12}$')

    def parse_params(self):
        params = web.input()
        appid = params.get('appid', '').lower()
        idfa  = params.get('idfa', '').upper()
        mac   = params.get('mac', '').upper()

        if appid == '' or not self.re_appid.match(appid):
            return False
        if idfa == '' or not self.re_idfa.match(idfa):
            return False
        if mac == '' or not self.re_mac.match(mac):
            return False

        self.appid = appid
        self.idfa = idfa
        self.mac = mac
        return True

    def GET(self):
        if not self.parse_params():
            return json.dumps({'success':False, 'message':'参数错误'}, ensure_ascii=False)

        userid, device_id = self.query_userid()
        if userid < 0:
            logger.debug('invalid device, idfa:%s, mac:%s' %(self.idfa, self.mac))
            return json.dumps({'success':True, 'message':''})

        self.report_app_callback(device_id, userid)
        return json.dumps({'success':True, 'message':''})
            
    def query_userid(self):
        url = ACCOUNT_BACKEND + '/userid'
        resp = self.make_request(url, 'GET', {'idfa':self.idfa, 'mac':self.mac})
        if resp['rtn'] == 0:
            return resp['userid'], resp['device_id']

    def report_app_callback(self, device_id, userid):
        url = TASK_BACKEND + '/app_callback'
        self.make_request(url, 'POST', {'device_id':device_id, 'userid':userid, 'appid':self.appid})


    def make_request(self, url, method, data, timeout = 3):
        logger.debug('url: %s, data: %s' %(url, json.dumps(data, ensure_ascii=False)))
        if method.upper() == 'POST':
            req = urllib2.Request(url, urllib.urlencode(data))
        else:
            req = urllib2.Request(url + '?' + urllib.urlencode(data))

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






