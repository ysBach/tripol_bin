#!/bin/sh

# option
# (none) : print $datadir/$filename_base, increment counter
# -d : print $datadir
# -n : print counter
# -s nn : set counter to nn

if [ -z "$DATAROOT" ]; then
	DATAROOT=/data
fi
if [ ! -d $DATAROOT ]; then
	echo "`basename $0` Error: invalid DATAROOT" 1>&2
	exit 1
fi
hour=`date +%-H`
if [ $hour -lt 8 ]; then
	whichday=yesterday
else
	whichday=today
fi
#datestr=`date -d $whichday +%Y%m%d`
datest2=`date -d $whichday +%y%m%d`
datadir=$DATAROOT/$datest2/rawdata
numfile=$DATAROOT/$datest2/next.txt
num=1
if [ ! -d $datadir ]; then
	mkdir -p $datadir
	if [ $? -ne 0 ]; then
		echo "`basename $0` Error: cannot make $datadir" 1>&2
		exit 1
	fi
fi
if [ "$1" = "-d" ]; then
	echo $datadir
	exit 0
fi
if [ -f $numfile ]; then
	read tmp < $numfile
	if [ "$tmp" -ge 0 ]; then
		num=$tmp
	fi
fi
if [ "$1" = "-n" ]; then
	echo $num
	exit 0
fi
if [ "$1" = "-s" ]; then
	nn=$2
	if [ -z "$nn" ]; then
		echo "usage: `basename $0` -s num" 1>&2
		exit 1
	fi
	if [ "$nn" -ge 0 -a "$nn" -le 100000 ]; then
		echo $nn > $numfile
		exit 0
	else
		echo "`basename $0` -s : bad num" 1>&2
		exit 1
	fi
fi
if [ -n "$1" ]; then
	echo "`basename $0`: invaid option" 1>&2
	exit 1
fi
numstr=`printf %04d $num`
echo ${datadir}/${datest2}_${numstr}
num=`expr $num + 1`
echo $num > $numfile
exit 0
