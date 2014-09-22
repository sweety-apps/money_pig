#!/bin/env python
# -*- coding: utf-8 -*-


import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import web

class Handler:
    def GET(self):
        return "Hello, world"

urls = (
    '/hello', Handler,
)

web.config.debug = True
#web.internalerror = web.debugerror

app = web.application(urls, globals(), autoreload=False)

if __name__ == '__main__':
    app.run()
else:
    application = app.wsgifunc()