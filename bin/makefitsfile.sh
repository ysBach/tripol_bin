#!/bin/sh

#  makefitsfile.sh
#  make fits file from ccd binary data and header info

. $TRIPOL_DEF_FILE

usage ()
{
	echo "usage: `basename $0` band fitsname"
	echo "  band: $band_1 $band_2 $band_3"
	echo "  template files below will be used to make fits header:"
	echo "    $sitedef_file"
	echo "    ${header_base}.*"
	echo "    ${header_base}_{$band_1|$band_2|$band_3}.*"
}

get_val ()
{
	#arg1: header file
	#arg2: key
	local header=$1
	local key=$2
	val=`grep ^$key $header | cut -d '=' -f 2 | cut -d '/' -f 1`
	val=`echo $val`
	echo $val
}

band=$1
fits=$2

case $band in
	$notused)
		exit 0
		;;
	$band_1)
		imrotopt="$img_rot_1"
		;;
	$band_2)
		imrotopt="$img_rot_2"
		;;
	$band_3)
		imrotopt="$img_rot_3"
		;;
	*)
		usage 1>&2
		exit 1
		;;
esac

if [ -z "$fits" ]; then
	usage 1>&2
	exit 1
fi

tmpheader=$tmp_dir/tmpheader.$band
tmpfits=$tmp_dir/`basename $fits`

# get ccd binary data
bindat=$bindat_base.$band
$getbin_cmd $band $bindat
test $? -eq 0 || exit 1

# get ccd header info
$ccd1_cmd $band header > $tmpheader
test $? -eq 0 || exit 1
width=`get_val $tmpheader xwidth`
height=`get_val $tmpheader yheight`


# add more header info
for hh in $sitedef_file ${header_base}.* ${header_base}_${band}.*; do
	test -f $hh && cat $hh >> $tmpheader
done

# Update some header keywords
# echo "start python"
python $tripol_dir/headerupdater.py --tmpheader $tmpheader --tmpfits $tmpfits
# echo "end python"

# make fits file
fitscopy ${bindat}[ul$width,$height] !$tmpfits
test $? -eq 0 || exit 1

# edit fits header
$header_cmd $tmpfits $tmpheader
test $? -eq 0 || exit 1

# rotate/flip image
test -n "$imrotopt" && imrot -o $imrotopt $tmpfits > /dev/null

cp -p $tmpfits $fits
rm -f $tmpfits $tmpheader
exit 0

