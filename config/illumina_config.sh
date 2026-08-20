#!/bin/bash
# Configuration file for Illumina pipeline

# Base directories
# Edit these paths to match your system
DATA_DIR="/proj/rumen_interaction/data/boran_rumen/Illumina"
RESULTS_DIR="/proj/rumen_interaction/NOBACKUP/results/Illumina"

COUNTING_DIR="${RESULTS_DIR}/counting"
GENOMES_DIR="/proj/rumen_interaction/NOBACKUP/genomes"

# Bowtie2 (host removal)
BOWTIE2_DIR="${RESULTS_DIR}/bowtie2"
BOWTIE2_INDEX="${BOWTIE2_DIR}/index_taurus"
ALIGNMENT_DIR="${BOWTIE2_DIR}/alignment"

# SeqKit (trimming / duplicate removal)
TRIM_DIR="${RESULTS_DIR}/trim"

# Sourmash (taxonomic profiling)
SOURMASH_DIR="${RESULTS_DIR}/taxa_res/sourmash/gtdb/pipeline"
GTDB_DB="${GENOMES_DIR}/GTDB/gtdb-rs207.genomic.k31.zip"
GTDB_TAXONOMY="${GENOMES_DIR}/GTDB/gtdb-rs207.taxonomy.with-strain.csv.gz"

# Kraken2 / Bracken (taxonomic profiling)
KRAKEN2_DIR="${RESULTS_DIR}/taxa_res/k2b"
KRAKEN2_DB="${GENOMES_DIR}/Kraken2"
K2_SOURMASH_DIR="${RESULTS_DIR}/taxa_res/kraken"

# FastQC / MultiQC output directories
FASTQC_RAW_DIR="${RESULTS_DIR}/full_analysis/fastqc_raw_rep"
FASTQC_UNMAP_DIR="${RESULTS_DIR}/full_analysis/fastqc_unmap_rep"
FASTQC_TRIM_DIR="${RESULTS_DIR}/full_analysis/fastqc_trim_rep"
FASTQC_UNCL_DIR="${RESULTS_DIR}/full_analysis/fastqc_uncl_rep"

# Counting files
RAW_COUNT_FILE="${COUNTING_DIR}/raw_count.txt"
UNMAP_COUNT_FILE="${COUNTING_DIR}/unmap_count.txt"
AFTER_DUPL_COUNT_FILE="${COUNTING_DIR}/count_qc_after_dupl.txt"
AFTER_NO_DUPL_COUNT_FILE="${COUNTING_DIR}/count_qc_after_no_dupl.txt"
UNCL_KRAKEN_COUNT_FILE="${COUNTING_DIR}/count_uncl_krake2.txt"

# Parameters
THREADS=20
KMER_SIZE=31
SCALING_ILLUMINA=30000
HOST_GENOME="Bos taurus"

# Create directories if they don't exist
mkdir -p "${RESULTS_DIR}"
mkdir -p "${BOWTIE2_DIR}"
mkdir -p "${ALIGNMENT_DIR}"
mkdir -p "${TRIM_DIR}"
mkdir -p "${SOURMASH_DIR}"
mkdir -p "${KRAKEN2_DIR}"
mkdir -p "${K2_SOURMASH_DIR}"
mkdir -p "${FASTQC_RAW_DIR}"
mkdir -p "${FASTQC_UNMAP_DIR}"
mkdir -p "${FASTQC_TRIM_DIR}"
mkdir -p "${FASTQC_UNCL_DIR}"
mkdir -p "${COUNTING_DIR}"
