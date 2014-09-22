
import web
import json
from config import *
from utils import *

logger = logging.getLogger('req_update_user_info')

class Handler:
    def POST(self):
        logger.debug('params: %s' %web.data())
        params = web.input()
        data = {
            'device_id': params.device_id,
            'userid': int(params.userid),
            'sex': int(params.sex),
            'age': int(params.age),
#            'area': params.area,
            'interest': params.interest
        }

        logger.debug('interest: ' + params.interest)

        url = 'http://' + ACCOUNT_BACKEND + '/update_user_info'

        r = http_request(url, data)
        if r['rtn'] == 0:
            self.report_task(params.device_id, params.userid)
            resp = {'res': 0, 'msg': ''}
        else:
            resp = {'res': 1, 'msg': 'error'}

        return json.dumps(resp)

    
    def report_task(self, device_id, userid):
        data = {
            'device_id': device_id,
            'userid': userid
        }
        url = 'http://' + TASK_BACKEND + '/report_user_info'
        http_request(url, data)

