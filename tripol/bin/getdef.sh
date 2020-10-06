#!/bin/bash

if [ "$1" = "-n" ]; then
	echoopt="-n"
	shift
fi
if [ -z "$1" ]; then
	echo "usage: `basename $0` [-n] def_name" 1>&2
	exit 1
fi
deffile=$TRIPOL_DEF_FILE
if [ ! -f "$deffile" ]; then
	echo "`basename $0` error: def_file $deffile not found" 1>&2
	exit 1
fi
#val=`cat $deffile | cut -d'#' -f1 | grep "$1=" | cut -d'=' -f2`
#val=`echo $val`
#echo -n "$val"

. $deffile
echo $echoopt "${!1}"

exit 0
