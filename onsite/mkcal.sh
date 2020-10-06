#!/bin/bash

. $TRIPOL_DEF_FILE

# enable job control
# set -m

myname=`basename $0`

usage ()
{
	echo "Quick master calibration frame maker (ysfitsutilpy + imcombinepy by ysBach@GitHub)"
	echo "usage: $myname [flatname]"
	echo ""
	echo "flatname: the name (OBJECT keyword) used for flat data (default='flat')."
}

flatname=$1
datadir=`nextdatafile -d`

python $tripol_dir/make_calib.py --flatname $flatname --datadir $datadir