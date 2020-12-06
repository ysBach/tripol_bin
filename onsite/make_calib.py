'''
A simple code to quickly make calibration frames.
May not be useful in general purposes.
Prepared in a hurry ....

2020-10-06 Y.P.Bach
'''
import argparse
from pathlib import Path

import imcombinepy as imc
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

# calibration frames
comb_kw = dict(
    reject='sc',
    irafmode=False,
    use_cfitsio=True
)

for filt in "gri":
    # *********************************************************************** #
    # *                             BIAS COMBINE                            * #
    # *********************************************************************** #
    list_bias = yfu.stack_FITS(
        summary_table=summary_raw,
        loadccd=False,
        type_key=["OBJECT", "FILTER"],
        type_val=["bias", filt]
    )
    _ = imc.fitscombine(
        list_bias,
        output=caldir/f"bias_{filt}.fits",
        **comb_kw
    )

    # *********************************************************************** #
    # *                             DARK COMBINE                            * #
    # *********************************************************************** #
    gs, g_key = yfu.group_FITS(summary_raw,
                               type_key=["OBJECT", "FILTER"],
                               type_val=["dark", filt],
                               group_key="EXPTIME")
    for g_val, group in gs:
        list_dark = yfu.stack_FITS(
            group["file"],
            type_key=g_key,
            type_val=g_val,
            load_ccd=False
        )
        _ = imc.fitscombine(
            list_dark,
            output=caldir/f"dark_{filt}_{g_val[-1]:.1f}.fits",
            **comb_kw
        )

    # *********************************************************************** #
    # *                             FLAT COMBINE                            * #
    # *********************************************************************** #
    list_flat = yfu.stack_FITS(
        summary_table=summary_raw,
        loadccd=False,
        type_key=["OBJECT", "FILTER"],
        type_val=["flat", filt]
    )
    _ = imc.fitscombine(
        list_flat,
        output=caldir/f"flat_{filt}.fits",
        scale="avg_sc",
        **comb_kw
    )
