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

echo "===> end......"