#!/bin/sh

#  readout.sh
#  readout ccd data (let ccd camera to make binary data)

. $TRIPOL_DEF_FILE

usage ()
{
	echo "usage: `basename $0` band exptime [dark]"
	echo "  band: $band_1 $band_2 $band_3"
}

band=$1
exptime=$2
dark=$3

case $band in
	$notused)
		exit 0
		;;
	$band_1|$band_2|$band_3)
		;;
	*)
		usage
		exit 1
		;;
esac
if [ -z "$exptime" ]; then
	usage
	exit 1
fi

if [ "$dark" = "dark" ]; then
	ccdcommand="dark $exptime"
else
	ccdcommand="light $exptime"
fi

timefmt="%H:%M:%S.%N"

stamp1=`date +$timefmt | cut -b -12`
result=`$ccd1_cmd $band $ccdcommand`
stamp2=`date +$timefmt | cut -b -12`

hname=`hostname`
acqinfo=${header_base}_${band}.acqinfo

echo_acqinfo ()
{
	echo "filter = $band / Filter Name"
	echo "acqstart = $stamp1 / data acquisition start time on $hname"
	echo "acqend = $stamp2 / data acquisition  end  time on $hname"
}

echo_acqinfo > $acqinfo

if [ "$result" != "done" ]; then
	echo -n "`basename $0`: ccd error $band " 1>&2
	echo $result 1>&2
	exit 1
fi
exit 0

