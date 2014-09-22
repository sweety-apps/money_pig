#!/bin/bash

ps -ef | grep uWSGI | grep billing | awk '{print $2}' | xargs kill -9
ps -ef | grep uwsgi | grep billing | awk '{print $2}' | xargs kill -9

