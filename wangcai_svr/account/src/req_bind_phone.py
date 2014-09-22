# -*- coding: utf-8 -*-

import web
import json
import random
import logging
import db_helper
from config import *

logger = logging.getLogger('root')

class Handler:
    def init(self):
        params = web.input()
        self._device_id = params.device_id
        self._userid = int(params.userid)
        self._phone_num = params.phone

    def gen_invite_code(self, code_len=5):
        selection = '23456789ABCDEFGHJKLMNPQRSTWXYZ'
        code = ''
        for each in range(0, code_len):
            code += selection[random.randint(0, len(selection)-1)]
        return code

    def POST(self):
        self.init()
        if self._userid == 0:
            resp = self.bind_phone_num()
        else:
            resp = self.update_phone_num()
        return json.dumps(resp)

        
    def bind_phone_num(self):
        assert self._userid == 0

        #初次绑定手机,从anonymous_device转移到user_device
        anony = db_helper.query_anonymous_device(self._device_id)
        if anony is None:
            logger.error('query_anonymous_device failed!! device_id:%s' %self._device_id)    
            return {'rtn': 1}
        elif anony.flag == 1: #已被绑定
            logger.info('query_anonymous_device, flag=1, device_id:%s, userid:%d' %self._device_id, self._userid)
            user = db_helper.query_user_info(self._userid)
            n = db_helper.count_user_device(self.userid)
            return {'rtn': 0, 'userid': self._userid, 'invite_code': user.invite_code, 'inviter': user.inviter_code, 'total_device': n}
            
        else:
            invite_code = self.gen_invite_code()
            user = db_helper.insert_user_info(self._phone_num, anony.sex, anony.age, anony.interest, invite_code)
            assert user is not None and user.userid != 0
            n = db_helper.count_user_device(user.userid)

            if (user.userid in VIP_LIST and n >= 50) or (user.userid not in VIP_LIST and n >= 3):
                logger.info('too many devices, userid: %d' %user.userid)
                return {'rtn': 2}
            else:
                db_helper.insert_user_device(user.userid, self._device_id, anony.idfa, anony.mac, anony.platform)
                db_helper.update_anonymous_device_flag(self._device_id, 1)
                return {'rtn': 0, 'userid': user.userid, 'invite_code': user.invite_code, 'inviter': user.inviter_code, 'total_device': n}

    def update_phone_num(self):
        logger.info('update phone num, userid:%d, device_id:%s, phone:%s' %(self._userid, self._device_id, self._phone_num))
        assert self._userid != 0

        user = db_helper.query_user_info(self._userid)

        #重新绑定手机,只改user_info中的手机号
        db_helper.update_phone_num(self._userid, self._phone_num)
        return {'rtn': 0, 'userid': self._userid, 'invite_code': user.invite_code}

