
import urllib
import urllib2
import json
import uuid
import random
import time
import socket
import logging
from logging.handlers import RotatingFileHandler


def init_logger(path, level=logging.NOTSET, maxBytes=50*1024*1024, backupCount=20):
        logger = logging.getLogger()
        logger.setLevel(level)
        file_handler = RotatingFileHandler(path, maxBytes=maxBytes, backupCount=backupCount)
        file_handler.setFormatter(logging.Formatter("[%(asctime)s] [%(levelname)s] %(message)s", "%Y%m%d %H:%M:%S"))
        logger.addHandler(file_handler)

def http_request(url, data = None, timeout = 3):
    if data is not None:
        req = urllib2.Request(url, urllib.urlencode(data))
    else:
        req = urllib2.Request(url)

    logger = logging.getLogger('root')
    logger.debug(url)

    try:
        resp = urllib2.urlopen(req, timeout = timeout).read()
        logger.debug('resp: %s' %resp)
        return json.loads(resp)
    except urllib2.HTTPError, e:
        logger.error('httperror: ' + str(e))
        return {'rtn': -e.code}
    except urllib2.URLError, e:
        logger.error('urlerror: ' + str(e))
        if isinstance(e.reason, socket.timeout):
            return {'rtn': -1}
        else:
            return {'rtn': -2}
    
def generate_session_id():
    return str(uuid.uuid4())

def cur_timestamp():
    return int(time.time())

