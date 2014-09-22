#!/bin/bash

ps -ef | grep uWSGI | grep task | awk '{print $2}' | xargs kill -9
ps -ef | grep uwsgi | grep task | awk '{print $2}' | xargs kill -9

