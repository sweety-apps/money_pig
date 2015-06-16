# -*- coding: utf-8 -*-

import web
import json
import logging
import protocol
from config import *
from utils import *
from push_msg_center import PushMsgCenter
from session_manager import SessionManager

logger = logging.getLogger()

class Handler:
    def GET(self):
        req  = protocol.CallbackOfferWallChukongReq(web.input(), web.cookies())
        resp = protocol.CallbackOfferWallChukongResp()

        remote_ip = web.ctx.env.get ('HTTP_X_REAL_IP', web.ctx.ip)
        if remote_ip == '127.0.0.1':
            logger.error('[CHUKONG] can not get romote IP')
            return resp.dump_json()
        if True:
            if remote_ip != SERVER_IP_CHUKONG:
                logger.error('[CHUKONG] wrong romote IP %s, maybe attacker!!!' %remote_ip)
                return resp.dump_json()

        self.log_req(req)

        mac = req.mac.upper()
        idfa = req.idfa.upper()

        userid_req = self.query_userid(idfa,mac)
        if userid_req['rtn'] != 0:
            logger.error('[CHUKONG] can not query user id')
            return resp.dump_json()

        if userid_req['userid'] != 0:
            unique_task_id = 'chukong_' + str(userid_req['userid']) + '_' + req.transactionid
            inviter = self.query_inviter(userid_req['userid'])
        else:
            unique_task_id = 'chukong_' + str(userid_req['device_id']) + '_' + req.transactionid
            inviter = 0

        taskdes = req.taskname + '【' + req.adtitle + '】'

        if int(req.coins) > 0:
            rtn = self.report_chukong_point(userid_req['userid'], userid_req['device_id'], inviter, req.coins, unique_task_id, taskdes)
            if rtn != 0:
                logger.error('report_chukong_point failed!! rtn:%d' %rtn)
            else:
                #发推送通知
                PushMsgCenter.instance().send_push_msg(str(userid_req['device_id']),'赚到%.1f元:%s' %(float(req.coins)/10.0,taskdes))

        return resp.dump_json()


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

    def report_chukong_point(self, userid, device_id, inviter, point, unique_task_id, taskdes):
        params = {
            'device_id': device_id,
            'userid': userid,
            'type': 0,
            'increment': int(point),
            'inviter': inviter,
            'remark': '%s' %(taskdes),
            'unique_task_id': unique_task_id
        }
        url = 'http://' + TASK_BACKEND + '/report_task_offerwall'
        r = http_request(url, params)
        return r['rtn']

    def log_req(self, req):
        logger.debug('[CHUKONG] callback url = %s' %web.ctx.fullpath)
        logger.debug('[CHUKONG] request param:')
        logger.debug('os = %s' %req.os)
        logger.debug('os_version = %s' %req.os_version)
        logger.debug('idfa = %s' %req.idfa)
        logger.debug('mac = %s' %req.mac)
        logger.debug('imei = %s' %req.imei)
        logger.debug('ip = %s' %req.ip)
        logger.debug('transactionid = %s' %req.transactionid)
        logger.debug('coins = %s' %req.coins)
        logger.debug('adid = %s' %req.adid)
        logger.debug('adtitle = %s' %req.adtitle)
        logger.debug('taskname = %s' %req.taskname)
        logger.debug('taskcontent = %s' %req.taskcontent)
        logger.debug('token = %s' %req.token)
        logger.debug('sign = %s' %req.sign)
        return



