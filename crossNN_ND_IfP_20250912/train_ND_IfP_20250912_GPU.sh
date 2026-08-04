#!/bin/bash

# use appropriate venv

TRAINING_H5=/applications/bin2h5/ND_IfP_20250912.h5
MODEL_OUTPUT=/mnt/nvme_ssd_8TB/applications/crossNN_versions/crossNN-master_20250911/models/ND_IfP_20250912.pth
MODEL_PKL=/mnt/nvme_ssd_8TB/applications/crossNN_versions/crossNN-master_20250911/models/ND_IfP_20250912_NN.pkl

python training_IfP_01.py --data $TRAINING_H5 --epochs 1000 --learning_rate 0.0001 \
                          --weight_decay 0.00001 --mask_size 0.0025 \
                          --model_output $MODEL_OUTPUT --pickle_output $MODEL_PKL
