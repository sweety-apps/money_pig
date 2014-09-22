#!/bin/bash

cd `dirname $0`

/usr/local/bin/uwsgi --ini ../conf/interface_uwsgi.conf

