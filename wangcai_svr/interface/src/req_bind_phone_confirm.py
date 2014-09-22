# -*- coding: utf-8 -*-

import web
import json
import logging
import urllib
from config import *
from utils import *
from sms_center import *
from session_manager import SessionManager

logger = logging.getLogger('root')

class Handler:
    def POST(self):
        params = web.input()
        session_id = params.session_id
        userid = int(params.userid)
        device_id = params.device_id
        token = params.token
        sms_code = params.sms_code

        if not SessionManager.instance().check_session(session_id, device_id, userid):
            resp = {'res':401, 'msg':'登陆态异常'}
            return json.dumps(resp, ensure_ascii=False)

        ret = SMSCenter.instance().check_sms(token, sms_code)
        if ret is None:
            logger.info('check sms code failed!! token:%s, code:%s' %(token, sms_code))
            resp = {'res': 1, 'msg': 'error'}
        else:
            action, data = ret
            #修改状态
            SMSCenter.instance().update_status(token, SMSStatus.SMS_CONFIRMED)
            
            if action != SMSAction.BIND_PHONE:
                resp = {'res': 1, 'msg': 'error'}
            else:
                resp = self.apply_bind_phone(json.loads(data))

                if resp['res'] == 0:
                    if userid == 0:
                        #绑定成功,需要进行帐号迁移
                        userid = resp['userid']
                        r = self.activate_account(userid, device_id)
                        if r['rtn'] == 0:
                            resp['balance'] = r['balance']
                            resp['income'] = r['income']
                            resp['outgo'] = r['outgo']
                            resp['shared_income'] = r['shared_income']

                        #修改cache中的userid
                        SessionManager.instance().update_session(session_id, device_id, userid)
                    else:
                        #查询余额
                        r = self.query_balance(userid, device_id)
                        if r['rtn'] == 0:
                            resp['balance'] = r['balance']
                            resp['income'] = r['income']
                            resp['outgo'] = r['outgo']
                            resp['shared_income'] = r['shared_income']
                            
        return json.dumps(resp)


    def apply_bind_phone(self, data):
        url = 'http://' + ACCOUNT_BACKEND + '/bind_phone'
        r = http_request(url, data)
        if r['rtn'] == 2:
            return {'res': 1, 'msg': '每个手机号至多绑定3台设备'}
        elif r['rtn'] != 0:
            return {'res': 1, 'msg': 'error'}
        else:
            return {
                'res': 0,
                'msg': '',
                'userid': r['userid'],
                'invite_code': r['invite_code'],
                'inviter': r['inviter'],
                'total_device': r['total_device']
            }


    def query_balance(self, userid, device_id):
        data = {'userid': userid, 'device_id': device_id}
        url = 'http://' + BILLING_BACKEND + '/query_balance?' + urllib.urlencode(data)
        r = http_request(url)
        if r['rtn'] == 0:
            return {
                'rtn': 0,
                'balance': r['balance'],
                'income': r['income'],
                'outgo': r['outgo'],
                'shared_income': r['shared_income']
            }
        else:
            return {'rtn': r['rtn']}
            

    def activate_account(self, userid, device_id):
        data = {'userid': userid, 'device_id': device_id}
        url = 'http://' + BILLING_BACKEND + '/activate_account'
        r = http_request(url, data)
        if r['rtn'] == 0:
            return {
                'rtn': 0,
                'balance': r['balance'],
                'income': r['income'],
                'outgo': r['outgo'],
                'shared_income': r['shared_income']
            }
        else:
            return {'rtn': r['rtn']}

