# -*- coding: utf-8 -*-

import web 
import re
import json
import urllib
import logging
import memcache
import protocol
from config import *
from utils import *
from session_manager import SessionManager

logger = logging.getLogger('root')

class Handler:
    def __init__(self):
        self.re_idfa = re.compile('[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}$')
        self.re_mac = re.compile('[0-9A-F]{12}$')

    def POST(self):
        req  = protocol.RegisterReq(web.input(), web.cookies())
        resp = protocol.RegisterResp()

        if not self.re_idfa.match(req.idfa) or not self.re_mac.match(req.mac):
            resp.res = 1
            resp.msg = '参数错误'
            return resp.dump_json()
        
        cookies = web.cookies()
        logger.debug('cookies: platform=%s, version=%s%s, network=%s' \
                %(cookies.get('p', ''), 
                    cookies.get('app', ''),
                    cookies.get('ver', ''),
                    cookies.get('net', '')))
        logger.debug('client ip: %s' %web.ctx.ip)

        #服务器维护
        if SWITCH_SERVER_DOWN == 1:
            resp.res = 511
            resp.msg = SWITCH_SERVER_DOWN_MSG
            return resp.dump_json()

        #配置提现开关
        if SWITCH_NO_WITHDRAW == 1:
            resp.no_withdraw = 1

        #配置TIPS
        if SWITCH_SERVER_TIPS == 1:
            resp.tips = SWITCH_SERVER_TIPS_CONTENT

        #配置积分墙开关
        resp.offerwall = {'domob': 0, 'youmi': 1}

        #配置强制升级
        if cookies.get('app', '').lower() != 'wangcai' and cookies.get('ver', '') in ['1.1', '1.1.1', '1.2', '1.3', '']:
            resp.force_update = 1
            return resp.dump_json()

        #屏蔽2g/3g用户
        if cookies.get('app', '').lower() != 'wangcai' and cookies.get('net', '') == '3g':
            logger.info('2g/3g user, ban! idfa:%s, mac:%s' %(req.idfa, req.mac))
            resp.res = 403
            resp.msg = '错误$当前IP访问的机器数过高，为了保证广告商的推广效果，您的设备今日无法继续使用旺财，请明日再试。'
            return resp.dump_json()


        data = {
            'idfa': req.idfa,
            'mac': req.mac,
            'platform': cookies.get('p', ''),
            'version': cookies.get('app', '') + cookies.get('ver', ''),
            'network': cookies.get('net', ''),
            'ip': web.ctx.ip,
        }

        url = 'http://' + ACCOUNT_BACKEND + '/register'

        r = http_request(url, data)
        if r['rtn'] == 1:
            resp.res = 403
            resp.msg = '错误$当前IP访问的机器数过高，为了保证广告商的推广效果，您的设备今日无法继续使用旺财，请明日再试。'
            return resp.dump_json()
        elif r['rtn'] == 2:
            resp.res = 403
            resp.msg = '错误$您当前的IP及绑定账号被广告商判断为异常，您的账号已被冻结，导致此问题的原因可能是通过重置系统重复完成任务。如需申诉，请邮件手机号及问题至wangcai@188.com。'
            return resp.dump_json()
        elif r['rtn'] != 0:
            resp.res = 1
            resp.msg = 'error'
            return resp.dump_json()

        resp.userid = userid = r['userid']
        resp.device_id = device_id = r['device_id']
        resp.phone = r['phone_num']
        resp.inviter = r['inviter']
        resp.invite_code = r['invite_code']

        #创建session缓存
        resp.session_id = SessionManager.instance().create_session(device_id, userid)

        if r['new_device']:
            logger.info('new device, idfa:%s, mac:%s' %(req.idfa, req.mac))

        data = {
            'userid': userid,
            'device_id': device_id
        }

        url = 'http://' + BILLING_BACKEND + '/query_balance?' + urllib.urlencode(data)

        logger.info('billing request, url = %s' %(url))

        r = http_request(url)
        if r['rtn'] == 0:
            resp.balance = r['balance']
            resp.income = r['income']
            resp.outgo = r['outgo']
            resp.shared_income = r['shared_income']
            resp.task_list = self.query_task_list(userid, device_id)

        return resp.dump_json()


    def query_task_list(self, userid, device_id):
        #查设备任务
        url = 'http://' + TASK_BACKEND + '/list/task_of_device?device_id=' + device_id
        r = http_request(url)
        if r['rtn'] == 0:
            task_map = dict([(task['id'], task) for task in r['task_list']])
        else:
            task_map = {}
            
        #已绑定,查帐号任务
        if userid != 0:
            url = 'http://' + TASK_BACKEND + '/list/task_of_user?userid=' + str(userid)
            r = http_request(url)
            if r['rtn'] == 0:
                for task in r['task_list']:
                    if task['id'] in task_map:
                        if task_map[task['id']]['status'] != 0:
                            status = task_map[task['id']]['status']
                        elif task['status'] != 0:
                            status = task['status']
                        else:
                            status = 0
                        #相同id的任务进行合并
                        task_map[task['id']]['status'] = status
                    else:
                        task_map[task['id']] = task

        #为苹果审核屏蔽
        app = web.cookies().get('app', '')
        ver = web.cookies().get('ver', '')
        if app.lower() == 'wangcai' and ver in ['1.1', '1.2']:
            if 5 in task_map:
                del task_map[5]
            if 6 in task_map:
                del task_map[6]

        return sorted(task_map.values(), key=lambda x: x['id'])

