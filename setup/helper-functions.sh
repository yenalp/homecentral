#!/usr/bin/env bash

log() {
	MSG=$1
	LOGFILE="/var/log/bootstrap.log"
	TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
	bash -c "echo $TIMESTAMP' '$MSG >> $LOGFILE"
}

cl() {
	local __msg=$1
	local __status=$2
	local __blue='\e[34m'
	local __red='\e[31m'
	local __green='\e[92m'
	local __magenta='\e[95m'
	local __orange='\e[33m'
	local __default='\e[39m'

	if [ "${__status}" = "-e" ]; then # e is for error
		local __colour=${__red}
		local __icon="\e[31m\xF0\x9F\x92\x80  ERROR:"
	elif [ "${__status}" = "-s" ]; then # s is for Success
		local __colour=${__magenta}
		local __icon="\xe2\x9c\x93 SUCCESS:"
	elif [ "${__status}" = "-f" ]; then # f is for failure
		local __colour=${__red}
		local __icon="\xe2\x9c\x95 FAIL:   "
	elif [ "${__status}" = "-w" ]; then # w is for Warning
		local __colour=${__orange}
		local __icon="\xE2\x9A\xA0 WARNING:"
	else
		local __colour=${__blue}
		local __icon="\xE2\x84\xB9 INFO:   "
	fi

	local __nc='\e[0m' # No Color
	echo -e "${__nc}${__colour}${__icon} ${__default}${__msg}${__nc}"

	if [[ $* == *-l* ]]; then # l is for log
		log ${__msg}
	fi
}