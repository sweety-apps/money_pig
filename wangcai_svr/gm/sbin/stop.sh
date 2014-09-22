#!/bin/bash

cd `dirname $0`

/usr/local/bin/uwsgi --stop ../conf/gm.pid

