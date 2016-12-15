#!/bin/bash

## critical and warning argument number of queue
_warn_arg_=$1
_crit_arg_=$2

## define exit code of Nagios
_ok_code_=0
_warn_code_=1
_crit_code_=2
_unk_code_=3

## get environment variable
_find_path_=$(which find)
_postfix_dir_=$(postconf queue_directory | awk '{print $NF}')

## check argument
if [ $# != 2 ];then
    echo "UNKNOWN! USAGE: $0 [Warning Args] [Critical Args]"
    exit ${_unk_code_}
fi

if [ ${_warn_arg_} -gt ${_crit_arg_} ];then
    echo "UNKNOWN! MUST BE [Warning Args] < [Critical Args]"
    exit ${_unk_code_}
fi

## count up mail queue
_num_incoming_queue_=$(sudo ${_find_path_} ${_postfix_dir_}/incoming/ -type f | wc -l)
_num_active_queue_=$(sudo ${_find_path_} ${_postfix_dir_}/active/ -type f | wc -l)
_num_deferred_queue_=$(sudo ${_find_path_} ${_postfix_dir_}/deferred/ -type f | wc -l)
_num_total_queue_=$((${_num_incoming_queue_}+${_num_active_queue_}+${_num_deferred_queue_}))


## check mailq if mail queue is over
if [ ${_num_total_queue_} -gt ${_warn_arg_} ];then
    if [ ${_num_total_queue_} -gt ${_crit_arg_} ];then
        echo "CRITICAL! Total Queue:${_num_total_queue_} [incoming:${_num_incoming_queue_}/active:${_num_active_queue_}/deferred:${_num_deferred_queue_}] [Threshold WARNING:${_warn_arg_}/CRITICAL:${_crit_arg_}]"
        exit ${_crit_code_}
    else
        echo "WARNING! Total Queue:${_num_total_queue_} [incoming:${_num_incoming_queue_}/active:${_num_active_queue_}/deferred:${_num_deferred_queue_}] [Threshold WARNING:${_warn_arg_}/CRITICAL:${_crit_arg_}]"
        exit ${_warn_code_}
   fi
else
    echo "OK! Total Queue:${_num_total_queue_} [incoming:${_num_incoming_queue_}/active:${_num_active_queue_}/deferred:${_num_deferred_queue_}] [Threshold WARNING:${_warn_arg_}/CRITICAL:${_crit_arg_}]"
    exit ${_ok_code_}
fi
