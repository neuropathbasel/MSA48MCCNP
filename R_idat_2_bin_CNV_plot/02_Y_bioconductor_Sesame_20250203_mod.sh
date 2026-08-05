#!/applications/R-4.4.1_SeSaMe_github_20250203/R-4.4.1/bin/Rscript

install.packages("remotes", repos = "http://cran.us.r-project.org")
require(remotes)
install_version("curl", version = "6.2.1", repos = "http://cran.us.r-project.org")


install.packages("devtools", repos="https://cloud.r-project.org/")

# install CRAN dependencies
install.packages("BiocManager", repos="https://stat.ethz.ch/CRAN/")


BiocManager::install("DNAcopy", update = FALSE, ask = FALSE)
BiocManager::install("Repitools") #for conversion of GRanges object inside seg object of SeSaMe to dataframe 
library(devtools)
#install sesame form github
#install_github("zwdzwd/sesame")
BiocManager::install("sesame")
