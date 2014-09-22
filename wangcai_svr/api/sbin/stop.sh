#!/bin/bash

ps -ef | grep uWSGI | grep api | awk '{print $2}' | xargs kill -9
ps -ef | grep uwsgi | grep api | awk '{print $2}' | xargs kill -9

