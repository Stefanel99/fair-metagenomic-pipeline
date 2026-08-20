#!/bin/bash
# Configuration file for Nanopore pipeline

# Base directories

# Edit these paths to match your system
DATA_DIR="/proj/rumen_interaction/data/boran_rumen/Nanopore"
RESULTS_DIR="/proj/rumen_interaction/NOBACKUP/results/Nanopore"

COUNTING_DIR="${RESULTS_DIR}/counting"
INDEX_DIR="${RESULTS_DIR}/minimap2/indexes"
MINIMAP2_DIR="${RESULTS_DIR}/minimap2"
GENOMES_DIR="/proj/rumen_interaction/NOBACKUP/genomes"

# Create directories if they don't exist
mkdir -p "${RESULTS_DIR}/chopper"
mkdir -p "${RESULTS_DIR}/fastq_rep"
mkdir -p "${RESULTS_DIR}/fastq_rep_trim"
mkdir -p "${RESULTS_DIR}/fastq_rep_map"
mkdir -p "${MINIMAP2_DIR}/results"
mkdir -p "${COUNTING_DIR}"
mkdir -p "${RESULTS_DIR}/sourmash/GTDB/pipeline"
mkdir -p "${RESULTS_DIR}/kraken2"
mkdir -p "${RESULTS_DIR}/k2_sourmash"

# Parameters
PHRED_SCORE=10
THREADS=12
KMER_SIZE=31
SCALING_NANOPORE=100000
GTDB_DB="${GENOMES_DIR}/GTDB/gtdb-rs207.genomic.k31.zip"
KRAKEN2_DB="${GENOMES_DIR}/Kraken2"
