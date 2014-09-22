# -*- coding: utf-8 -*-

import web
import logging
import protocol
import db_helper
from data_types import *
from billing_client import BillingClient

logger = logging.getLogger()

class Handler:
    def POST(self):
        req  = protocol.AppCallback_Req(web.input())
        resp = protocol.AppCallback_Resp()

        logger.debug('got app callback, device_id:%s, appid:%s' %(req.device_id, req.appid))

        self.device_id = req.device_id
        self.appid = req.appid

        if not self.app_downloaded():
            logger.info('failed in task_app_download, device_id:%s, appid:%s' %(req.device_id, req.appid))
            return resp.dump_json()

        task = self.query_task_info()
        if task is not None:
            t = TaskOfDevice()
            t.device_id = req.device_id
            t.userid = req.userid
            t.task_id = task.id
            t.type = TaskType.T_APP
            t.status = TaskStatus.S_DONE
            t.money = task.money
            n = db_helper.insert_task_of_device(t)
            if n == 0:
                logger.error('insert task_of_device failed')
            else:
                logger.info('task_app succeed! device_id:%s, appid:%s' %(req.device_id, req.appid))
                BillingClient.instance().recharge(req.device_id, req.userid, task.money, 'app: %s, %s' %(req.appid, task.app_name))

        return resp.dump_json()

    def app_downloaded(self):
        return db_helper.query_task_app_download(self.device_id, self.appid)

    def query_task_info(self):
        task = db_helper.query_task_app_by_appid(self.appid)
        if task is None:
            logger.error('unknown appid!! %s' %self.appid)
            return None
        else:
            return task


        


