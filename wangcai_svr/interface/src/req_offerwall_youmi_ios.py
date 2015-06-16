# -*- coding: utf-8 -*-

import web
import json
import logging
import protocol
import hashlib
from config import *
from utils import *
from push_msg_center import PushMsgCenter
from session_manager import SessionManager

logger = logging.getLogger()

class Handler:
    def GET(self):
        req  = protocol.CallbackOfferWallYoumiIOSReq(web.input(), web.cookies())
        resp = protocol.CallbackOfferWallYoumiIOSResp()

        self.log_req(req)

        server_key = SERVER_KEY_YOUMI
        if self.check_signature(req, server_key) != 1:
            logger.error('[YOUMI] signature wrong')
            return resp.dump_json()

        mac = ''
        device = ''

        #根据长度判断是idfa还是mac地址
        if len(req.device) > 17 :
            device = req.device.upper()
        else:
            mac = req.device.upper()

        #查用户信息
        userid_req = self.query_userid(device , mac)
        if userid_req['rtn'] != 0:
            logger.error('[YOUMI] can not query user id')
            return resp.dump_json()

        if userid_req['userid'] != 0:
            unique_task_id = 'youmi_' + str(userid_req['userid']) + '_' + req.order
            inviter = self.query_inviter(userid_req['userid'])
        else:
            unique_task_id = 'youmi_' + str(userid_req['device_id']) + '_' + req.order
            inviter = 0

        taskdes = '试用' + '【' + req.ad + '】'

        if float(req.price) > 0.0:
            income = float(req.price) * 10.0 * YOUMI_USER_PRICE_RATIO
            rtn = self.report_youmi_point(userid_req['userid'], userid_req['device_id'], inviter, income, unique_task_id, taskdes)
            if rtn != 0:
                logger.error('report_youmi_point failed!! rtn:%d' %rtn)
            else:
                #发推送通知
                PushMsgCenter.instance().send_push_msg(str(userid_req['device_id']),'赚到%.1f元:%s' %(float(int(income))/10.0,taskdes))

        return resp.dump_json()

    def check_signature(self, req, server_key):
        raw_string = ''
        #key字典序升序排列
        raw_string = raw_string + 'ad=' + req.ad
        raw_string = raw_string + 'adid=' + req.adid
        raw_string = raw_string + 'app=' + req.app
        raw_string = raw_string + 'chn=' + req.chn
        raw_string = raw_string + 'device=' + req.device
        raw_string = raw_string + 'order=' + req.order
        raw_string = raw_string + 'points=' + req.points
        raw_string = raw_string + 'price=' + req.price
        raw_string = raw_string + 'sig=' + req.sig
        raw_string = raw_string + 'storeid=' + req.storeid
        raw_string = raw_string + 'time=' + req.time
        raw_string = raw_string + 'user=' + req.user
        raw_string = raw_string + server_key

        logger.info('[YOUMI] md5 raw string = %s' %raw_string)

        sign = hashlib.md5(raw_string.encode("utf8")).hexdigest()

        logger.info('[YOUMI] md5 calculated sign = %s' %sign)
        
        if req.sign == sign:
            return 1

        return 0


    def query_inviter(self, userid):
        url = 'http://' + ACCOUNT_BACKEND + '/inviter?userid=' + str(userid)
        r = http_request(url)
        if r['rtn'] == 0:
            return r['inviter']
        else:
            return 0

    def query_userid(self, idfa, mac):
        if len(idfa) <= 0 and len(mac) <= 0:
            return {'rtn': -1}
        url = 'http://' + ACCOUNT_BACKEND + '/userid?idfa=' + str(idfa) + '&mac=' + str(mac)
        resp = http_request(url)
        if resp['rtn'] == 0:
            return {'rtn':resp['rtn'], 'userid':resp['userid'], 'device_id':resp['device_id']}
        else:
            return {'rtn':resp['rtn']}

    def report_youmi_point(self, userid, device_id, inviter, point, unique_task_id, taskdes):
        params = {
            'device_id': device_id,
            'userid': userid,
            'type': 1,
            'increment': int(point),
            'inviter': inviter,
            'remark': '%s' %(taskdes),
            'unique_task_id': unique_task_id
        }
        url = 'http://' + TASK_BACKEND + '/report_task_offerwall'
        r = http_request(url, params)
        return r['rtn']

    def log_req(self, req):
        logger.debug('[YOUMI] callback url = %s' %web.ctx.fullpath)
        logger.debug('[YOUMI] request param:')
        logger.debug('order = %s' %req.order)
        logger.debug('app = %s' %req.app)
        logger.debug('ad = %s' %req.ad)
        logger.debug('adid = %s' %req.adid)
        logger.debug('user = %s' %req.user)
        logger.debug('device = %s' %req.device)
        logger.debug('chn = %s' %req.chn)
        logger.debug('price = %s' %req.price)
        logger.debug('points = %s' %req.points)
        logger.debug('time = %s' %req.time)
        logger.debug('storeid = %s' %req.storeid)
        logger.debug('sig = %s' %req.sig)
        logger.debug('sign = %s' %req.sign)
        return

