# Train crossNN with ND_IfP_20250912
This code works best with a CUDA GPU-equipped computer, e.g., NVIDIA RTX4090 or A5000; alternatively ORIN 64GB developer kit. Adapt to CPU-only pytorch if intended. **Consider this code as example.** Example data are provided in this repository. Adapt to your operating system and available hardware acceleration.

## Set up a Python 3.9 virtual environment
Consult [setting_up_python_venv_20260203.txt](https://github.com/neuropathbasel/MSA48MCCNP/tree/main/crossNN_ND_IfP_20250912/setting_up_python_venv_20260203.txt).

## Run bin2h5
Build an HDF5 file from NanoDiP-compatible bin files. Example data contained [herein](https://github.com/neuropathbasel/MSA48MCCNP/tree/main/crossNN_ND_IfP_20250912/bin2h5).

## Train crossNN with HDF5 dataset
Adjust pathes to your setup and run [train_ND_IfP_20250912_GPU.sh](https://github.com/neuropathbasel/MSA48MCCNP/tree/main/crossNN_ND_IfP_20250912/train_ND_IfP_20250912_GPU.sh). Depending on your hardware, this can take several hours. This needs to be done only once. Note: If you train on a particular GPU architecture, the model won't run on another. The models has to be trained on the same architecture as it will be used (not necessarily the exact same GPU), i.e. you can't train on an RTX4090 and run the model on an ORIN 64GB but instead need to train the model again on the ORIN. Potential differences between various CPU platforms have not been evaluted.

## Classify methylation data with crossNN
Use the Jupyter notebook [classify_NN_bedMethyl_04.ipynb](https://github.com/neuropathbasel/MSA48MCCNP/tree/main/crossNN_ND_IfP_20250912/classify_NN_bedMethyl_04.ipynb) as a template. The notebook contains generated output for reference. Adjust pathes accordingly.
