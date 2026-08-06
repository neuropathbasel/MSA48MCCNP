#!/bin/bash

# J. Hench IfP 2025
# demonstrate the functionality of bin2hdf5.py

cd '/applications/bin2h5'
./bin2h5_01.py '/applications/bin2h5/demo_data/betaEPIC450Kmix_bin' '/applications/bin2h5/demo_data/demo_annotation.xlsx' '/applications/bin2h5/demo_data/demo_refset.h5'

echo "examining output"
h5dump '/applications/bin2h5/demo_data/demo_refset.h5' | head -n50
