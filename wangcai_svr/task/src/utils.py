
import urllib
import urllib2
import json
import uuid
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
#        req = urllib2.Request(url, urllib.urlencode(data))
        try:
#            resp = urllib2.urlopen(req, timeout = timeout)
#            return json.loads(resp.read())
            return {'rtn': '0',
                    'device_id': '1234567',
                    'userid': 12345,
                    'phone': '130311'}
        except urllib2.URLError, e:
            if isinstance(e.reason, socket.timeout):
                return {'rtn': '-1'}
            else:
                return {'rtn': '-2'}
    
def generate_session_id():
    return str(uuid.uuid1())

