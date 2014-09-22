#!/bin/bash

cd `dirname $0`

/usr/local/bin/uwsgi --ini ../conf/app_uwsgi.conf

