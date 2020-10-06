''' A quick code to preprocess one frame.
Prepared in a hurry ....

2020-10-06 Y.P.Bach
'''
import argparse
from pathlib import Path

import ysfitsutilpy as yfu


parser = argparse.ArgumentParser()

parser.add_argument('--dir')
parser.add_argument('--flatname', default="flat", type=str)
args = parser.parse_args()

flatname = args.flatname
datadir = Path(args.dir)
topdir = datadir.parent

caldir = topdir/"calibration"

rawfits = datadir.glob("*.fits")

USEFUL_KEYS = ["EXPTIME", "FILTER", "DATE-OBS", "RET-ANG1",
               "OBJECT", "EPOCH", "RA", "DEC", "ALT", "AZ", "AIRMASS"]

summary_raw = yfu.make_summary(rawfits, keywords=USEFUL_KEYS)


