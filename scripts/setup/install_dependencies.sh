#!/bin/bash
# Installation Guide for the Software Necessary for this Metagenomic Analysis
# Source: Bachelor's Thesis, Tarnauceanu Stefan (2024), SLU Uppsala

echo "Installing Conda"
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
conda init base

echo "Installing FastQC"
conda install fastqc

echo "Installing MultiQC"
conda install multiqc

echo "Installing Samtools"
sudo apt install samtools

echo "Installing SeqKit"
conda install -c bioconda seqkit

echo "Installing Bowtie2"
sudo apt install bowtie2

echo "Installing Minimap2"
sudo apt install minimap2

echo "Installing Sourmash"
bash Miniforge3-Linux-x86_64.sh
~/miniforge3/bin/mamba init
echo 'source ~/.bashrc' > ~/.bash_profile
source ~/.bash_profile
mamba install sourmash

echo "Installing Kraken2"
sudo apt install kraken2

echo "Installing Bracken"
conda install bioconda::bracken

echo "Installing Krona"
mamba install krona
mamba update krona

echo "Installing Pavian on R"
Rscript -e '
install.packages("BiocManager")
BiocManager::install("Rsamtools")
install.packages("remotes")
remotes::install_github("fbreitwieser/pavian")
'

echo "All dependencies installed!"
