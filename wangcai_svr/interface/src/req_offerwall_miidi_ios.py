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
        req  = protocol.CallbackOfferWallMiidiReq(web.input(), web.cookies())
        resp = protocol.CallbackOfferWallMiidiResp()

        self.log_req(req)

        server_key = SERVER_KEY_MIIDI_IOS

        if self.check_signature(req, server_key) != 1:
            logger.error('[MIIDI] signature wrong')
            return resp.dump_json()

        mac = ''
        idfa = ''

        #根据长度判断是idfa还是mac地址
        if len(req.imei) > 17 :
            idfa = req.imei.upper()
        else:
            mac = req.imei.upper()

        #查用户信息
        userid_req = self.query_userid(idfa , mac)
        if userid_req['rtn'] != 0:
            logger.error('[MIIDI] can not query user id')
            return resp.dump_json()

        if userid_req['userid'] != 0:
            unique_task_id = 'miidi_' + str(userid_req['userid']) + '_' + req.trand_no
            inviter = self.query_inviter(userid_req['userid'])
        else:
            unique_task_id = 'miidi_' + str(userid_req['device_id']) + '_' + req.trand_no
            inviter = 0

        taskdes = '试用' + '【' + req.appName + '】'

        if float(req.cash) > 0.0:
            income = req.cash
            rtn = self.report_miidi_point(userid_req['userid'], userid_req['device_id'], inviter, income, unique_task_id, taskdes)
            if rtn != 0:
                logger.error('report_miidi_point failed!! rtn:%d' %rtn)
            else:
                #发推送通知
                PushMsgCenter.instance().send_push_msg(str(userid_req['device_id']),'赚到%.1f元:%s' %(float(int(income))/10.0,taskdes))

        return resp.dump_json()

    def check_signature(self, req, server_key):
        raw_string = ''
        raw_string = raw_string + req.id
        raw_string = raw_string + req.trand_no
        raw_string = raw_string + req.cash
        raw_string = raw_string + req.param0
        raw_string = raw_string + server_key

        logger.info('[MIIDI] md5 raw string = %s' %raw_string)

        sign = hashlib.md5(raw_string.encode("utf8")).hexdigest()

        logger.info('[MIIDI] md5 calculated sign = %s' %sign)
        
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

    def report_miidi_point(self, userid, device_id, inviter, point, unique_task_id, taskdes):
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
        logger.debug('[MIIDI] callback url = %s' %web.ctx.fullpath)
        logger.debug('[MIIDI] request param:')
        logger.debug('id = %s' %req.id)
        logger.debug('trand_no = %s' %req.trand_no)
        logger.debug('cash = %s' %req.cash)
        logger.debug('imei = %s' %req.imei)
        logger.debug('bundleId = %s' %req.bundleId)
        logger.debug('param0 = %s' %req.param0)
        logger.debug('appName = %s' %req.appName)
        logger.debug('sign = %s' %req.sign)
        return

