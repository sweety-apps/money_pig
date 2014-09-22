#!/bin/bash

cd `dirname $0`

/usr/local/bin/uwsgi --reload ../conf/gm.pid

