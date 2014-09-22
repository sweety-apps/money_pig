#!/bin/bash

ps -ef | grep uWSGI | grep account  | awk '{print $2}' | xargs kill -9
ps -ef | grep uwsgi | grep account  | awk '{print $2}' | xargs kill -9

