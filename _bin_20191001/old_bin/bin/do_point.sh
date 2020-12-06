#!/bin/sh

. $TRIPOL_DEF_FILE

header=$header_base.point

usage () {
	echo "`basename $0`: point telescope with info:"
	echo "    $point_base_file"
	echo "    $point_offset_file"
}

if [ "$1" = "clear" -o "$1" = "-clear" ]; then
	rm -f $header
	exit 0
fi

command=$1
if [ "$command" != "point" -a "$command" != "offset" ]; then
	echo "`basename $0`: invalid command: $command" 1>&2
	exit 1
fi

if [ "$2" = "no_point" ]; then
	flag=$2
	shift
fi

if [ "$2" ]; then
	usage 1>&2
	exit 1
fi

# check file timestamp
for f in $point_base_file $point_offset_file $header; do
	f2=`basename $f`
	if [ "`find $tmp_dir -name $f2 -mmin +480`" ]; then
		echo "`basename $0`: Warning: $f is too old. delete it"
		rm $f
	fi
done

# get base
test -f $point_base_file && read epoch ra_base dec_base < $point_base_file
if [ $command = point ]; then
	if [ -z "$ra_base" -o -z "$dec_base" ]; then
		echo "`basename $0`: $point_base_file: invalid ra dec" 1>&2
		exit 1
	fi
fi

# get offset
test -f $point_offset_file && read ra_off dec_off < $point_offset_file
if [ $command = offset ]; then
	if [ -z "$ra_off" -o -z "$dec_off" ]; then
		echo "`basename $0`: $point_offset_file: invalid offset" 1>&2
		exit 1
	fi
else
	test -z "$ra_off" && ra_off=0
	test -z "$dec_off" && dec_off=0
fi

# make fits header template
echo_template () {
	echo "pointinf = '`date`' / timestamp of pointing info"
	test "$epoch" && echo "epoch = '$epoch' / epoch"
	echo "ra = '$ra_base' / hh:mm:ss.s RA (pointing base)"
	echo "dec = '$dec_base' / dd:mm:ss.s Dec (pointing base)"
	echo "ra_off = $ra_off / [arcsec] Ra offset"
	echo "dec_off = $dec_off / [arcsec] DEC offset"
}
echo_template > $header

test "$flag" = "no_point" && exit 0
$do_point_tel_cmd $command "$epoch" "$ra_base" "$dec_base" "$ra_off" "$dec_off"
exit $?
