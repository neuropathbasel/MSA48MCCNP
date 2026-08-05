setwd('/home/minknow/R_working_dir_2026_01_09/')
getwd()
library(sesame)
library(illuminaio)
library(GenomicRanges)

sesameDataCache()


#define Path ot directory with idats of reference files
idat_dir='/applications/reference_data/ND_IfP_20250912_idat/'
prefixes <- searchIDATprefixes(idat_dir)
prefixes

#cross check 
NoIdats <- length(prefixes)

print("Number of idatas found:")
print(NoIdats)

IdatpairName <- attributes(prefixes)
print(IdatpairName)

#set path to index csv from this repo
index <- read.csv('/applications/reference_data/ND_IfP_20250912_bin/index.csv', header=F, stringsAsFactors=F)
colnames(index) <- 'CPGs'
index$RoID <- row.names(index) #additional row ids to see the effect of merge function
head(index)

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
  
  BinPath="/applications/reference_data/ND_IfP_20250912_bin/"
  BinFileName <- paste(BinPath,"/",SentrixID, "_sesame.19.1.10_prep_CDB_coll_PFX_T.bin", sep="")
  print("BinFileName:")
  print(BinFileName)
  Betas <- openSesame(prefixes[i], prep='CDB', collapseToPfx=TRUE, func = getBetas, BPPARAM = BiocParallel::MulticoreParam(11))
  CPGs <- attributes(Betas)$names
  BetasVector <- as.double(Betas) #remove attributes from beta values - so merge function below will work
  CountCPGs <- length(CPGs)
  ndf <- data.frame(CPGs=character(CountCPGs), Betas=double(CountCPGs))
  ndf$CPGs <- CPGs
  ndf$Betas <- BetasVector
  headndf <- head(ndf)
  print('head ndf:')
  print(headndf)
  
  #merge data frame with index to focus on IfP CPGs
  ndf.subset <- merge( index, ndf,  by = "CPGs", all.x = TRUE)
  headndf.subset <- head(ndf.subset)
  print("headndf.subset")
  print(headndf.subset)
  
  ndf.subset.re.sorted <- ndf.subset[order(match(ndf.subset[,1],index[,1])),]
  head.ndf.subset.re.sorted <- head(ndf.subset.re.sorted)
  print("head.ndf.subset.re.sorted:")
  print(head.ndf.subset.re.sorted)
  
  #replace NA by Median of subsetted betavalues
  MedianBeta <- median(ndf.subset.re.sorted$Betas, na.rm = TRUE)
  ndf.subset.re.sorted.na.replaced <- ndf.subset.re.sorted
  ndf.subset.re.sorted.na.replaced[is.na(ndf.subset.re.sorted.na.replaced)] <- MedianBeta
  head.ndf.subset.re.sorted.na.replaced <- head(ndf.subset.re.sorted.na.replaced)
  print("head.ndf.subset.re.sorted.na.replaced")
  print(head.ndf.subset.re.sorted.na.replaced)
  
  #write bin file
  writeBin(ndf.subset.re.sorted.na.replaced$Beta, BinFileName)
  
}
