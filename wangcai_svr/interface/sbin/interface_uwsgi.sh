#!/bin/bash

cd `dirname $0`

server_name="account"
server_num=1
conf_file="../conf/${server_name}_uwsgi.conf"
uwsgi_bin="/usr/local/bin/uwsgi"
log_dir="../log"

#export PATH=/usr/local/python27/bin:$PATH
#export PYTHONHOME=/usr/local/python27/

HELP_STR="${server_name}_uwsgi.sh - a manager script for ${server_name}\n\n"

get_uwsgi_num()
{
    uwsgi_name=$1
    num=$(ps -ef | grep "uWSGI" | grep "$uwsgi_name" | grep -v "grep" | wc -l)
    return $num
}

get_master_num()
{
    uwsgi_name=$1
    num=$(ps -ef | grep "uWSGI" | grep "$uwsgi_name" | grep "master" | grep -v "grep" | wc -l)
    return $num
}

HELP_STR="$HELP_STR\tmonitor \t - monitor ${server_name}\n"
monitor()
{
    if [ $server_num -eq 1 ];then
        monitor_uwsgi ${server_name}
        exit
    fi
    for ((i=1;i<=$server_num;++i));do
        monitor_uwsgi ${server_name}_$i
    done
}

monitor_uwsgi()
{
    uwsgi_name=$1
    get_master_num $uwsgi_name
    if [ $? -eq 0 ];then
        #mv $log_dir $log_dir.$(date +%Y%m%d.%H%M%S)
        #mkdir $log_dir
        restart_uwsgi $uwsgi_name
        send_mail "$uwsgi_name started at $HOSTNAME"  "$(date); $server_name"
    else
        echo "${uwsgi_name} is running!"
    fi
}

HELP_STR="$HELP_STR\tstart \t\t - start ${server_name}\n"
start()
{
    if [ $server_num -eq 1 ];then
        start_uwsgi ${server_name}
        exit
    fi
    for ((i=1;i<=$server_num;++i));do
        start_uwsgi ${server_name}_$i
    done
}

start_uwsgi()
{
    uwsgi_name=$1
    if [ $server_num -eq 1 ];then
        ${uwsgi_bin} --ini ${conf_file}
    else
        ${uwsgi_bin} --ini ${conf_file}:$uwsgi_name
    fi
    sleep 1
    get_master_num $uwsgi_name
    if [ $? -eq 0 ];then
        echo "Start $uwsgi_name failed!"
        exit
    else
        echo "$uwsgi_name started!"
    fi
}

kill9_uwsgi()
{
    uwsgi_name=$1
    ps -ef | grep "uWSGI" | grep "${uwsgi_name}" | grep -v grep | awk '{print $2}' | while read pid
    do
        kill -9 $pid
    done
    echo "kill $uwsgi_name forcedly!"
}

HELP_STR="$HELP_STR\tkill9 \t\t - kill ${server_name}\n"
kill9()
{
    if [ $server_num -eq 1 ];then
        kill_uwsgi ${server_name}
        exit
    fi
    for ((i=1;i<=$server_num;++i));do
        kill_uwsgi ${server_name}_$i
    done
}

kill_uwsgi()
{
    uwsgi_name=$1
    get_uwsgi_num $uwsgi_name
    if [ $? -eq 0 ];then
        echo "$uwsgi_name is not running!"
        return 0
    fi
    get_master_num $uwsgi_name
    if [ ! $? -eq 0 ];then
        pid=$(ps -ef | grep "uWSGI" | grep "$uwsgi_name" | grep "master" | awk '{print $2}')
        kill -3 $pid
        sleep 1
    else
        kill9_uwsgi $uwsgi_name
    fi
    get_uwsgi_num $uwsgi_name
    if [ $? -gt 0 ];then
        kill9_uwsgi $uwsgi_name
    fi
    echo "$uwsgi_name killed!"
}

restart_uwsgi()
{
    uwsgi_name=$1
    kill_uwsgi $uwsgi_name
    start_uwsgi $uwsgi_name
}


HELP_STR="$HELP_STR\trestart \t - restart ${server_name}\n"
restart()
{
    if [ $server_num -eq 1 ];then
        restart_uwsgi ${server_name}
        send_mail "$uwsgi_name restarted at $HOSTNAME"  "$(date); $server_name"
        exit
    fi
    for ((i=1;i<=$server_num;++i));do
        restart_uwsgi ${server_name}_$i
        send_mail "$uwsgi_name restarted at $HOSTNAME"  "$(date); $server_name"
    done
}

if [ $# -eq 0 ];then
    printf "$HELP_STR\n"
else
    "$1"
    if [ $server_num -eq 1 ];then
        echo ""
        ps -ef | grep "uWSGI" | grep ${server_name} | grep -v "grep" | sort -n -k 11
        exit
    fi
    for ((i=1;i<=$server_num;++i));do
        echo ""
        ps -ef | grep "uWSGI" | grep ${server_name}_$i | grep -v "grep" | sort -n -k 11
    done
fi
