setwd("/home/minknow/R_working_dir_2026_01_09/")
getwd()
library(readxl)
library(Cairo)
library(ggplot2)
library(sesame)
library(illuminaio)
library(GenomicRanges)
sesameDataCache()

#sessionInfo()

#determine number of cores
all_cores <- parallel::detectCores()
ND_IfP_20250912_xlsx_stdSortArray <- read.csv('/data/epidip_temp/ND_IfP_20250912.xlsx_stdSortArray.csv')
head(ND_IfP_20250912_xlsx_stdSortArray)
ND_IfP_20250912_Top_500_CPGs <- ND_IfP_20250912_xlsx_stdSortArray[1:5000,]
head(ND_IfP_20250912_Top_500_CPGs)
type(ND_IfP_20250912_Top_500_CPGs)
ND_IfP_20250912_Top_500_CPGs_list <- ND_IfP_20250912_Top_500_CPGs$ilmnID
str(ND_IfP_20250912_Top_500_CPGs_list)

MSA_idatDir="/data/2026_01_15_IfP_MSA_idats"
SeSaMe_outputpath="/data/SeSaMe_output/" #location to store bins and probsuccessrate output file generated in this script

prefixes <- searchIDATprefixes(MSA_idatDir)
prefixes
print("Number of samples with idats:")
print(length(prefixes))

IdatpairName <- attributes(prefixes)
print(IdatpairName)

index <- read.csv('/applications/reference_data/ND_IfP_20250912_idat/index.csv', header=F, stringsAsFactors=F)
colnames(index) <- 'CPGs'
index$RoID <- row.names(index) #additional row ids to see the effect of merge function
head(index)

#For copynumber plots with SeSaMe
source ("/home/minknow/R_working_dir_2026_01_09/cnvNPB20250324.R")


#read idats of blood samples for cnv normalisation Mo 2025-03-31 corrected to remove gender bias.
MSA_Blut_samplesheet <- read.csv("/data/2026_01_15_IfP_MSA_idats/MSA_samples - Samplesheet_Blood_controls.csv", skip = 8)
MSA_Blut_samplesheet$SentrixID <- paste0(MSA_Blut_samplesheet$SentrixBarcode_A, "_",MSA_Blut_samplesheet$SentrixPosition_A, sep="")
MSA_Blut_samplesheet$Input.Menge.ng <- as.double(MSA_Blut_samplesheet$Input.Menge.ng)
head(MSA_Blut_samplesheet)

MSA_Blut_samplesheet$Input_Menge_str<- sprintf("%04.1f", MSA_Blut_samplesheet$Input.Menge.ng)
head(MSA_Blut_samplesheet)
MSA_Blut_samplesheet$Sample_Name_Input <- paste0(MSA_Blut_samplesheet$Sample_Name, "_",MSA_Blut_samplesheet$Input_Menge_str, sep="")

#MSA_Blut_samplesheet <- gsub("\\ ", "", MSA_Blut_samplesheet)
head(MSA_Blut_samplesheet)

#bloodNormalisationSet_50 <- MSA_Blut_samplesheet[MSA_Blut_samplesheet$Replicate=="10ng", c("SampleID_Input", "SentrixID")]
bloodNormalisationSet <- MSA_Blut_samplesheet[, c("Sample_Name_Input", "SentrixID")] #selected all input blood reference samples
head(bloodNormalisationSet)
nrow(bloodNormalisationSet)

#read in MSA sampleshhet from Bonn of brain biopsies on two arrays:

MSAsamplesheet <- read.csv("/data/2026_01_15_IfP_MSA_idats/MSA_samples - MSA_samplesheet_round1_2.csv", skip=8)

head(MSAsamplesheet)
MSAsamplesheet$SentrixID <- paste0(MSAsamplesheet$SentrixBarcode_A,"_",MSAsamplesheet$SentrixPosition_A)
MSAsamplesheet$InputMengeStr <- sprintf("%04.1f", MSAsamplesheet$Input.Menge.ng)# Wed 8.10.2025 from gemini
MSAsamplesheet$InputMengeStr <- gsub("\\.", "d", MSAsamplesheet$InputMengeStr) #d for digital separator
MSAsamplesheet$Sample_Name_Input <- paste0(MSAsamplesheet$Sample_Name,"_",MSAsamplesheet$InputMengeStr)

#CNV Normalisation Set = blood samples + 8 MNG_Ben_2_samples in FFPE
NormList <- list()
BloodNormList <- bloodNormalisationSet$Sample_Name_Input

#add MNG_Ben_2 samples to normalisation set
MNG_Ben_2_samples <- c('Sample.34','Sample.35','Sample.36','Sample.37','Sample.38','Sample.39','Sample.40','Sample.41')
MNG_normalisationSubset <- MSAsamplesheet[MSAsamplesheet$Sample_Name %in% MNG_Ben_2_samples,]
head(MNG_normalisationSubset)
MNG_normalisationSubset <- MNG_normalisationSubset[, c('Sample_Name_Input','SentrixID')]
head(MNG_normalisationSubset)

MNG_Norm_List <-MNG_normalisationSubset$Sample_Name_Input 
MNG_Norm_List

NormListNames <- c(BloodNormList, MNG_Norm_List)
NormListNames
NormListNames[1]
NormListNames[63]
length(NormListNames)

imax=0

for (i in 1:nrow(bloodNormalisationSet)) {
  print('i:')
  print(i)
  SentrixID <- bloodNormalisationSet[i,"SentrixID" ]
  SentrixPath <- paste0("/data/MSA_Blood_sample_IDATS/MSA/",SentrixID, sep="")
  SentrixPath <- gsub("\\ ", "", SentrixPath)
  print(SentrixPath)
  sdf <- readIDATpair(SentrixPath)
  #NormList50 <- append(NormList50, list(sdf))
  NormList[[NormListNames[i]]] <- sdf
  imax=imax+1
}
head (NormList)
length(NormList)
print('imax:')
print(imax)

for (j in 1:nrow(MNG_normalisationSubset)) {
  print('j:')
  print(j)
  k= j + imax
  print('k:')
  print(k)
  
  SentrixID <- MNG_normalisationSubset[j,"SentrixID" ]
  SentrixPath <- paste0("/data/2026_01_15_IfP_MSA_idats/",SentrixID, sep="")
  SentrixPath <- gsub("\\ ", "", SentrixPath)
  print(SentrixPath)
  sdf <- readIDATpair(SentrixPath)
  NormList[[NormListNames[k]]] <- sdf
  
}
head (NormList)
length(NormList)


#create plots for samples specified in the MSA_samplessheet_rout_1_2
for (i in 1:length(prefixes)) {
  
  print("i:")
  print(i)
  print(IdatpairName$names[i])
  print(prefixes[i])
  #derive original Idat name from green channel
  grn.name <- paste0(prefixes[i],"_Grn.idat")
  print("GRN name:")
  print(grn.name)
  ida.grn <- suppressWarnings(illuminaio::readIDAT(grn.name))
  SentrixID <- paste(ida.grn$Barcode, ida.grn$Unknowns$MostlyA, sep="_")
  print("SentrixID:")
  print(SentrixID)
  
  sdf <- readIDATpair(prefixes[i])
  # print("sdf:")
  # print(sdf)

  #Probe success rate for the entire array; should be > 0.7 to produce meaningful results
  PSR <- probeSuccessRate(sdf, mask = TRUE, max_pval = 0.05)
  
  PSR_FileName <- paste(SeSaMe_outputpath,"/",SentrixID, "_PSR.txt", sep="")
  write.table(PSR,PSR_FileName, row.names = FALSE, col.names = FALSE)
  
 
  selection_list <- ND_IfP_20250912_Top_500_CPGs_list
  head(selection_list)

  sdf_short_ids <- sub("_.*", "", sdf$Probe_ID)
  head(sdf_short_ids)
  sdf_subset <- sdf[sdf_short_ids %in% selection_list, ]
  sdf_subset


  PSR_subset <- probeSuccessRate(sdf_subset, mask = TRUE, max_pval = 0.05)
  PSR_subset_Filename <- paste(SeSaMe_outputpath,"/",SentrixID, "_PSR_subset.txt", sep="")
  write.table(PSR_subset,PSR_subset_Filename, row.names = FALSE, col.names = FALSE)

  Betas <- openSesame(sdf, prep='CDB', collapseToPfx=TRUE, func = getBetas, BPPARAM = BiocParallel::MulticoreParam(safe_cores))
  CPGs <- attributes(Betas)$names
  BetasVector <- as.double(Betas) #remove attributes from beta values - so merge function below will work
  CountCPGs <- length(CPGs)
  ndf <- data.frame(CPGs=character(CountCPGs), Betas=double(CountCPGs))
  ndf$CPGs <- CPGs
  ndf$Betas <- BetasVector
  ndf.match <- merge( index, ndf,  by = "CPGs", all.x = TRUE)

  ndf.match.re.sorted <- ndf.match[order(match(ndf.match[,1],index[,1])),]

  MedianBeta <- median(ndf.match.re.sorted$Betas, na.rm = TRUE)
  ndf.match.re.sorted.na.replaced <- ndf.match.re.sorted
  ndf.match.re.sorted.na.replaced[is.na(ndf.match.re.sorted.na.replaced)] <- MedianBeta
  head.ndf.match.re.sorted.na.replaced <- head(ndf.match.re.sorted.na.replaced)
  print("head.ndf.match.re.sorted.na.replaced")
  print(head.ndf.match.re.sorted.na.replaced)
  
  #write beta vector as a bin file
  BinFileName <- paste(SeSaMe_outputpath,"/",SentrixID, "_sesame_19_1_10_prep_CDB_coll_PFX_T.bin", sep="")
  print("BinFileName:")
  print(BinFileName)
  writeBin(ndf.match.re.sorted.na.replaced$Beta, BinFileName)
  
  #copy number plot for each array
  PngFilename <- paste(SeSaMe_outputpath,"/", SentrixID,"_sesame_19_1_10_CNVplot.png", sep="")
  print("PngFilename:")
  print(PngFilename)
  seg <-  cnSegmentation(sdf, sdfs.normal = NormList)
  options(bitmapType="cairo")
  ggsave(PngFilename, visualizeSegmentsNpb(seg), width = 8, height = 6, units = "in", dpi = 300)
  
}