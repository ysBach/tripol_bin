#!/bin/sh

band=$1
bindat=$2

if [ -z "$bindat" ]; then
	echo "`basename $0` error: binary filename unknown" 1>&2
	exit 1
fi
if [ ! -f $bindat ]; then
	echo "`basename $0` error: binary datafile $bindat not exist" 1>&2
	exit 1
fi
exit 0
