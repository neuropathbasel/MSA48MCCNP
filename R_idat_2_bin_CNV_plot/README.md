# R4.4.1/ SeSaMe 1.24 setup and use

The following scripts have been developed on xUbuntu 20.04.6 LTS on  PC with a NVIDIA GeForce RTX 2070 and CUDA Version: 12.2. Adaptations to the following code may be needed when using different versions of Linux distributions or hardware.

Copy all files in this repo e.g. to ~/Documents

Please read and try to understand the shell scripts for later troubleshooting.

## Install R-4.4.1
Running 
~/Documents$./01_X_R_4_4_1_for_SesaMe_biocoductor_20250203.sh

will create a directory called:
"/applications/R-4.4.1_SeSaMe_github_20250203/R-4.4.1"

In this directory R-4.4.1 will be installed

## Install SeSaMe 1.24.0

~/Documents$./02_Y_bioconductor_Sesame_20250203_mod.sh
will install sesame and the required dependencies

To use R-4.4.1 in Rstudio, add

export RSTUDIO_WHICH_R=/applications/R-4.4.1_SeSaMe_github_20250203/R-4.4.1/bin

to

 ~/.profile

and source this file running

~$ source ~/.profile


## SessionInfo()
> sessionInfo()
> 
R version 4.4.1 (2024-06-14)

Platform: x86_64-pc-linux-gnu

Running under: Ubuntu 20.04.6 LTS


Matrix products: default

BLAS:   /applications/R-4.4.1_SeSaMe_github_20250203/R-4.4.1/lib/libRblas.so 

LAPACK: /applications/R-4.4.1_SeSaMe_github_20250203/R-4.4.1/lib/libRlapack.so;  LAPACK version 3.12.0


locale:

 [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C               LC_TIME=de_CH.UTF-8        LC_COLLATE=en_US.UTF-8    
 
 [5] LC_MONETARY=de_CH.UTF-8    LC_MESSAGES=en_US.UTF-8    LC_PAPER=de_CH.UTF-8       LC_NAME=C                 
 
 [9] LC_ADDRESS=C               LC_TELEPHONE=C             LC_MEASUREMENT=de_CH.UTF-8 LC_IDENTIFICATION=C       
 

time zone: Europe/Zurich

tzcode source: system (glibc)


attached base packages:
[1] stats4    stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:

 [1] GenomicRanges_1.58.0 GenomeInfoDb_1.42.3  IRanges_2.40.1       S4Vectors_0.44.0     illuminaio_0.48.0   
 
 [6] sesame_1.24.0        sesameData_1.24.0    ExperimentHub_2.14.0 AnnotationHub_3.14.0 BiocFileCache_2.14.0
 
[11] dbplyr_2.5.0         BiocGenerics_0.52.0  ggplot2_3.5.1        Cairo_1.6-2         


loaded via a namespace (and not attached):

 [1] tidyselect_1.2.1            dplyr_1.1.4                 blob_1.2.4                  filelock_1.0.3             
 
 [5] Biostrings_2.74.1           fastmap_1.2.0               lifecycle_1.0.4             base64_2.0.2               
 
 [9] KEGGREST_1.46.0             RSQLite_2.3.9               magrittr_2.0.3              compiler_4.4.1             
[
13] rlang_1.1.5                 tools_4.4.1                 yaml_2.3.10                 askpass_1.2.1              

[17] S4Arrays_1.6.0              bit_4.6.0                   curl_6.2.1                  DelayedArray_0.32.0        

[21] plyr_1.8.9                  RColorBrewer_1.1-3          abind_1.4-8                 BiocParallel_1.40.0        

[25] purrr_1.0.4                 withr_3.0.2                 grid_4.4.1                  preprocessCore_1.68.0      

[29] wheatmap_0.2.0              colorspace_2.1-1            scales_1.3.0                SummarizedExperiment_1.36.0

[33] cli_3.6.4                   crayon_1.5.3                generics_0.1.3              rstudioapi_0.17.1          

[37] httr_1.4.7                  reshape2_1.4.4              tzdb_0.4.0                  DBI_1.2.3                  

[41] cachem_1.1.0                stringr_1.5.1               zlibbioc_1.52.0             parallel_4.4.1             

[45] AnnotationDbi_1.68.0        BiocManager_1.30.25         XVector_0.46.0              matrixStats_1.5.0          

[49] vctrs_0.6.5                 Matrix_1.7-2                jsonlite_1.9.1              hms_1.1.3                  

[53] bit64_4.6.0-1               glue_1.8.0                  codetools_0.2-20            stringi_1.8.4              

[57] gtable_0.3.6                BiocVersion_3.20.0          UCSC.utils_1.2.0            munsell_0.5.1              

[61] tibble_3.2.1                pillar_1.10.1               rappdirs_0.3.3              openssl_2.3.2              

[65] GenomeInfoDbData_1.2.13     R6_2.6.1                    Biobase_2.66.0              lattice_0.22-6 

[69] readr_2.1.5                 png_0.1-8                   memoise_2.0.1               Rcpp_1.0.14 

## Convert Idats of the ND_IfP_20250912 reference set to bin format for use in NanoDiP.

Download reference idats from GEO and copy them to 

/applications/reference_data/ND_IfP_20250912_idat/

Copy index.csv from this repo to the path for this path as well.

Copy ND_IfP_20250912.xlsx from this repo to

/applications/reference_data/reference_annotations/


In Rsutdio open:

03_Ref_Idat_2_bin_SeSaMe_BPPARAM.R


and adapt hard coded paths to your settings. 

Run this Rscript on all idats of the reference set ND_IfP_20250912.

## For each SentrixID of the IfP MSA set generate Methoverlap.tsv and CNVplot.png files

Copy 
cnvNPB20250324.R

from this repo to a directory of your choice and adjust  the Path in the source command in the following Rscript:

05_MSA_samples_Sesame_prefixes_SentrixIDs_for_FileNames_Bin_PSR_CNV_plot.R

From 

https://docs.google.com/spreadsheets/d/1MepAtLnVNEO7foGta7fxKHaQ3AF35tlgC9Cg9OUTHng/edit?gid=1517620021#gid=1517620021
Select the sheet “Samplesheet_Blood_controls and download it as a csv.

Set the path to the storage location in above script in line starting with

“MSA_Blut_samplesheet <- read.csv”

Form above google sheet select the MSA_sampleheet_round_1_2 as a csv and set the path in line starting with 
“MSAsamplesheet <- read.csv()”

The same information can be found in the attached file 
MSA_samples.xlsx.

Adjust all paths to your local setup

Run this script.

It will create for each Sentrix ID a CNVplot.png a bin file and additional files required by NanoDiP for classifying the MSA idats generated in this study.


