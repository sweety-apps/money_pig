#!/bin/bash

ps -ef | grep uWSGI | grep interface | awk '{print $2}' | xargs kill -9
ps -ef | grep uwsgi | grep interface | awk '{print $2}' | xargs kill -9

