#!/usr/bin/env python

# J. Hench IfP Basel
# run in a virtual environment

# Dependencies
import sys
import numpy as np
import pandas as pd
import os
import h5py
from tqdm import tqdm

# Function definitions
def read_bin_index_file(index_filename):
    with open(index_filename, 'r') as indexFile:
        cgnames = indexFile.readlines()
        cgnames = [name.strip() for name in cgnames]
    return cgnames

def read_one_binary_file(betas_filename):
    with open(betas_filename, 'rb') as betasFile:
        allBetaSingleFile = np.fromfile(betasFile, dtype=float)
    return allBetaSingleFile

def get_sentrix_id(bin_file_name):
  suffix="_betas_filtered.bin"
  sentrix_id=bin_file_name.replace(suffix,"")
  return sentrix_id


# execute

# check command line argument validity
if len(sys.argv) > 2:
	print("Arguments provided:")
	for arg in sys.argv:
		print(arg)
	binary_file_directory=sys.argv[1]
	print("INPUTPATH="+str(binary_file_directory))
	annotation_xlsx_file=sys.argv[2]
	print("ANNOTATIONXLSX="+str(annotation_xlsx_file))
	output_file=sys.argv[3]
	print("OUTPUTH5FILE="+str(output_file))
	
else:
	print("No arguments provided. Provide INPUTPATH to bin files, ANNOTATIONXLSX, and OUTPUTH5FILE to write HDF5 file")
	sys.exit(1) # Exit with an error code

#binary_file_directory="/content/nanodxData/betaEPIC450Kmix_bin"
#annotation_xlsx_file="/content/nanodxData/demo_annotation.xlsx"

# read index and determine number of probes
cpgindex=read_bin_index_file(binary_file_directory+"/index.csv")
num_cpgs=len(cpgindex)
print(str(num_cpgs)+" probes found in index file.")

# determine number of bin files defined in annotation
annotation_df = pd.read_excel(annotation_xlsx_file,header=None)
annotation_df.columns=['Sentrix_ID','MC','Description']

num_annotations=len(annotation_df)
print(str(num_annotations)+" annotations present in annotation file.")
#display(annotation_df)

# generate a list of all *.bin files in binary_file_directory
all_bin_files=[]
all_sentrix_ids=[]
for binfilename in tqdm(os.listdir(binary_file_directory)):
    if binfilename.endswith(".bin"):
#        print("Found file: "+str(binfilename))
        all_bin_files.append(binfilename)
        all_sentrix_ids.append(get_sentrix_id(binfilename))
#display(all_bin_files)
#display(all_sentrix_ids)
num_bin_files=len(all_bin_files)
print(str(num_bin_files)+" *.bin files in bin file directory.")

# determine if all Sentrix IDs specified in the annotation have a corresponding *.bin file
for anno in annotation_df['Sentrix_ID']:
  if anno not in all_sentrix_ids:
    print("Missing *.bin file for annotation: "+str(anno))

# read all selected bin files specified in annotation file into a numpy array
file_counter=0
betas_array=np.zeros((num_cpgs,num_annotations))
for anno in tqdm(annotation_df['Sentrix_ID']):
  if anno in all_sentrix_ids:
    bin_file_name=binary_file_directory+"/"+anno+"_betas_filtered.bin"
#    print("reading *.bin file: "+str(bin_file_name))
    betas_one_file=read_one_binary_file(bin_file_name)
# fill betas_one_file into a row of beta_array
    betas_array[:,file_counter]=betas_one_file
    file_counter+=1

# set path and dimensions for new h5 file based on which files were found and appear in the annotation xlsx file
#output_file = "/content/nanodxData/demo_reference_set.h5"

# Remove the file if it already exists
if os.path.exists(output_file):
    os.remove(output_file)

with h5py.File(output_file, 'a') as hf:
    # Add the 'Dx' dataset; shape is (num_annotations,) and dtype is variable-length string (ascii)
    hf.create_dataset('Dx', shape=(num_annotations,), dtype=h5py.string_dtype(encoding='ascii'))

    # Add the 'betaValues' dataset; shape is (num_new_probes, num_new_samples) and dtype is float64
    hf.create_dataset('betaValues', shape=(num_cpgs, num_annotations), dtype=np.float64)

    # Add the 'probeIDs' dataset; shape is (num_new_probes,) and dtype is variable-length string (ascii)
    vlen_str_dtype = h5py.string_dtype(encoding='ascii')
    hf.create_dataset('probeIDs', shape=(num_cpgs,), dtype=vlen_str_dtype)

    # Add the 'sampleIDs' dataset; shape is (num_new_samples,) and dtype is variable-length string (ascii)
    hf.create_dataset('sampleIDs', shape=(num_annotations,), dtype=vlen_str_dtype)
print(f"Added 'betaValues', 'probeIDs', and 'sampleIDs' datasets to '"+str(output_file)+"'.")

# write the content to h5 file
with h5py.File(output_file, 'a') as hf:
    hf['Dx'][...]=annotation_df['MC'].to_list()
    hf['betaValues'][...]=betas_array
    hf['probeIDs'][...]=cpgindex
    hf['sampleIDs'][...]=annotation_df['Sentrix_ID'].to_list()
print("done.")
