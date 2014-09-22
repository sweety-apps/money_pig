#!/bin/bash

echo "===> stopping old sever......"

../interface/sbin/stop.sh
../account/sbin/stop.sh
../task/sbin/stop.sh
../api/sbin/stop.sh
../billing/sbin/stop.sh
../gm/sbin/stop.sh
../app/sbin/stop.sh
../order/sbin/stop.sh

echo "===> starting new sever......"

./start_memcached.sh

../account/sbin/start.sh
../task/sbin/start.sh
../api/sbin/start.sh
../billing/sbin/start.sh
../gm/sbin/start.sh
../app/sbin/start.sh
../order/sbin/start.sh
../interface/sbin/start.sh

echo "===> end......"