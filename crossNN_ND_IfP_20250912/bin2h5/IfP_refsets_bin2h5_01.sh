#!/bin/bash

# J. Hench IfP 2025
# demonstrate the functionality of bin2hdf5.py

cd '/applications/bin2h5'
./bin2h5_01.py '/applications/reference_data/betaEPIC450Kmix_bin' '/applications/reference_data/reference_annotations/MNG_IfP_v1.xlsx'  '/applications/bin2h5/MNG_IfP_v1.h5'

echo "examining output"
h5dump '/applications/bin2h5/MNG_IfP_v1.h5' | head -n50

cd '/applications/bin2h5'
./bin2h5_01.py '/applications/reference_data/betaEPIC450Kmix_bin' '/applications/reference_data/reference_annotations/AllIDATv2_20210804_HPAP_Sarc.xlsx'  '/applications/bin2h5/AllIDATv2_20210804_HPAP_Sarc.h5'

echo "examining output"
h5dump '/applications/bin2h5/AllIDATv2_20210804_HPAP_Sarc.h5' | head -n50
