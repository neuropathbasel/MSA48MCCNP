#!/bin/bash

#Rdependencies
sudo apt-get -y install gcc-multilib \
 build-essential fort77 xorg-dev liblzma-dev libblas-dev \
 gfortran gobjc++ aptitude libreadline-dev libbz2-dev libpcre2-dev \
 libcurl4 libcurl4-openssl-dev default-jre default-jdk \
 openjdk-8-jdk openjdk-8-jre  texinfo texlive texlive-fonts-extra \
 libssl-dev libxml2-dev \
 libjpeg-dev wkhtmltopdf xorg-dev libreadline-dev pandoc

#R shared libaries according to
#https://community.rstudio.com/t/r-shared-library-usr-local-lib-r-lib-libr-so-not-found-if-this-is-a-custom-build-of-r-was-it-built-with-the-enable-r-shlib-option/126418 
sudo apt-get install -y gfortran libreadline6-dev libx11-dev libxt-dev \
                               libpng-dev libjpeg-dev libcairo2-dev xvfb \
                               libbz2-dev libzstd-dev liblzma-dev \
                               libcurl4-openssl-dev \
                               texinfo texlive texlive-fonts-extra \
                               screen wget libpcre2-dev
                               
#Install Linux System Dependencies
sudo apt update
sudo apt install build-essential libcurl4-gnutls-dev libxml2-dev libssl-dev libfontconfig1-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev                               

#biomanager dependencies:
sudo apt-get install libharfbuzz-dev libfribidi-dev
sudo apt-get install libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev



#R 4.3.0
venvpath=/applications/
cd $venvpath
myR="R-4.4.1"

myRbranch="R-4"
#startDir=`pwd`
cd $venvpath
myRstamp=$myR"_SeSaMe_github_20250203"
mkdir -p $myRstamp
cd $myRstamp
# local R installation
wget `echo "https://cloud.r-project.org/src/base/"$myRbranch"/"$myR".tar.gz"`
tar -xzvf `echo "./"$myR".tar.gz"`
cd $myR
./configure --enable-R-shlib
make
