''' 
A simple code to quickly make calibration frames.
May not be useful in general purposes.
Prepared in a hurry ....

2020-10-06 Y.P.Bach
'''
import ysfitsutilpy as yfu 
from pathlib import Path
import imcombinepy as imc
import argparse


parser = argparse.ArgumentParser()

parser.add_argument('--dir')
parser.add_argument('--flatname', default="flat", type=str)
args = parser.parse_args()

flatname = args.flatname
datadir = Path(args.dir)
allfits = datadir.glob("*.fits")

USEFUL_KEYS = ["EXPTIME", "FILTER", "DATE-OBS", "RET-ANG1",
               "OBJECT", "EPOCH", "RA", "DEC", "ALT", "AZ", "AIRMASS"]

summary = yfu.make_summary(allfits, keywords=USEFUL_KEYS)

# Bias combine
list_kw = dict(summary_table=summary, loadccd=False, 
               type_key=["OBJECT", "FILTER"])

for filt in "gri":
    list_bias = yfu.stack_FITS(type_val=["bias", filt], **list_kw)
    list_dark = yfu.stack_FITS(type_val=["dark", filt], **list_kw)
    list_flat = yfu.stack_FITS(type_val=[flatname, filt], **list_kw)
    
    imc.fitscombine(list_bias, )


