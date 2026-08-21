#!/bin/bash
# Databases Download Script
# Downloads reference databases needed for taxonomic profiling
# Source: Bachelor's Thesis, Tarnauceanu S. (2024), SLU Uppsala

echo "Downloading GTDB for sourmash..."
wget https://farm.cse.ucdavis.edu/~ctbrown/sourmash-db/gtdb-rs207/gtdb-rs207.genomic.k31.zip

echo "Downloading the Kraken2 Standard database for Kraken2 and Bracken..."
wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_20240605.tar.gz

echo "Databases downloaded!"
echo "Note: Total database size is approximately 87 GB (GTDB: 9.4 GB, Kraken2: 78 GB)."
echo "Please ensure you have sufficient disk space before proceeding."
