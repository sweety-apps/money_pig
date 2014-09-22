# -*- coding: utf-8 -*-


import web
import json


class Handler:
    def GET(self):
        input = web.input
        if not hasattr(input, 'appid') or not hasattr(input, 'mac') or not hasattr(input, 'idfa'):
            return json.dumps({'success':false, 'message':'参数错误'})

        appid = input.appid
        mac   = input.mac
        idfa  = input.idfa



