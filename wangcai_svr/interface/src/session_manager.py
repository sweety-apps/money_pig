# -*- coding: utf-8 -*-

import memcache
import uuid
import logging
from config import *

logger = logging.getLogger()

class SessionManager:

    s_instance = None

    @classmethod
    def instance(cls):
        if cls.s_instance is None:
            cls.s_instance = cls()
        return cls.s_instance

    def __init__(self):
        self._mc = memcache.Client(SESSION_MEMCACHE, debug=0)

    def gen_session_id(self):
        return str(uuid.uuid4())

    def find_session_by_device(self, device_id):
        return self._mc.get(str(SESSION_PREFIX + device_id))

    def find_session(self, session_id):
        return self._mc.get(str(SESSION_PREFIX + session_id))

    def create_session(self, device_id, userid):
        logger.debug('create session, device_id: %s, userid: %d' %(device_id, userid))
        #先查是否已有device->session的缓存
        session_id = self.find_session_by_device(device_id)
        if session_id is None:
            session_id = self.gen_session_id()
            logger.debug('create session, new session_id:%s, device_id:%s,userid:%d' \
                    %(session_id, device_id, userid))
            self.add_session_cache(session_id, device_id, userid)
            return session_id
        else:
            logger.debug('reuse session, session_id:%s, device_id:%s,userid:%d' \
                    %(session_id, device_id, userid))
            return session_id

    def check_session(self, session_id, device_id, userid):
        device = self.find_session(session_id)
        if device is None:
            logger.debug('check session failed! device is None, session_id: %s, device_id: %s' \
                        % (session_id, device_id))
            return False
        elif device['device_id'] == device_id:
            logger.debug('check session success, device_id:%s, userid:%d' %(device_id, userid))
            return True
        else:
            logger.debug('check session failed! session_id:%s, device_id:%s, userid:%d' \
                    %(session_id, device_id, userid))
            return False

    def add_session_cache(self, session_id, device_id, userid):
        logger.debug('add session, session_id:%s, device_id:%s, userid:%d' %(session_id, device_id, userid))
        self._mc.set(str(SESSION_PREFIX + session_id), 
                    {
                        'device_id': device_id,
                        'userid': userid
                    }, SESSION_LIVETIME)
        self._mc.set(str(SESSION_PREFIX + device_id), session_id, SESSION_LIVETIME) 

    def update_session(self, session_id, device_id, userid):
        logger.debug('update session, session_id:%s, device_id:%s, userid:%d' %(session_id, device_id, userid))
        self._mc.set(str(SESSION_PREFIX + session_id), 
                    {
                        'device_id': device_id,
                        'userid': userid
                    }, SESSION_LIVETIME)

    
if __name__ == '__main__':
#    session_id = SessionManager.instance().create_session('abcdefgss', 12345)
#    print 'session_id: ' + session_id
    ret = SessionManager.instance().check_session('2a41d740-5237-42ae-9016-f9c4d1cf2e86', 'eac888e9a73084fe863ba63f94fdfd73', 0)
    print 'check session returns ' + str(ret)



