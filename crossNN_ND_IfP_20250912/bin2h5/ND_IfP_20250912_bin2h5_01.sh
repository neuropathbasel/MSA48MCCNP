#!/bin/bash

# J. Hench IfP 2025
# run bin2hdf5.py

cd '/applications/bin2h5'
./bin2h5_01.py '/run/user/1000/gvfs/sftp:host=meqneuropatlp43.lan,user=minknow/RN22TBraid01/epidip/meqneuropatlp44/data/epidip_CpGs' '/applications/bin2h5/ref_anno_xlsx/ND_IfP_20250912.xlsx' '/applications/bin2h5/ND_IfP_20250912.h5'

echo "examining output"
h5dump '/applications/bin2h5/ND_IfP_20250912.h5' | head -n50
