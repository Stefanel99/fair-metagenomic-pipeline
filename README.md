# FAIR-Compliant Metagenomics Analysis Pipeline

Automated, reproducible pipeline for shotgun metagenomics analysis of Nanopore and Illumina sequencing data, developed following FAIR (Findable, Accessible, Interoperable, Reusable) principles.

## Overview

This pipeline was developed during my Bachelor's thesis internship at SLU (Swedish University of Agricultural Sciences) in collaboration with the rumen interaction research project. It processes metagenomic samples from Ethiopian Boran cattle rumen, comparing microbial community composition across two seasons (February dry season vs. July wet season).

### Pipeline Steps

**Nanopore workflow:**
1. Quality Control (FastQC + MultiQC)
2. Trimming (Chopper, Phred score ≥ 10)
3. Host Removal (Minimap2 → Bos taurus reference)
4. Taxonomic Profiling (sourmash / Kraken2+Bracken / Kraken2+sourmash)

**Illumina workflow:**
1. Quality Control (FastQC + MultiQC)
2. Host Removal (Bowtie2 → Bos taurus reference)
3. Trimming (SeqKit, duplicate removal)
4. Taxonomic Profiling (sourmash / Kraken2+Bracken / Kraken2+sourmash)

## Requirements

- Linux/Unix environment (HPC cluster recommended)
- Conda/Mamba for dependency management
- ~100 GB disk space for databases

### Software Dependencies

| Tool | Version | Purpose |
|------|---------|---------|
| FastQC | ≥0.11 | Quality control |
| MultiQC | ≥1.14 | Aggregate QC reports |
| Chopper | ≥0.5 | Nanopore trimming |
| SeqKit | ≥2.5 | Illumina trimming/dedup |
| Minimap2 | ≥2.24 | Nanopore host mapping |
| Bowtie2 | ≥2.4 | Illumina host mapping |
| Samtools | ≥1.15 | BAM/SAM manipulation |
| Seqtk | ≥1.4 | Read extraction |
| Sourmash | ≥4.8 | Taxonomic profiling (FracMinHash) |
| Kraken2 | ≥2.1 | Taxonomic profiling (k-mer) |
| Bracken | ≥2.7 | Abundance re-estimation |
| Krona | ≥2.8 | Visualization |
| Pavian | R package | Visualization (Shiny) |

### Databases

| Database | Size | Used by |
|----------|------|---------|
| GTDB R07-RS207 | 9.4 GB | sourmash |
| Kraken2 Standard (2024-06-05) | 78 GB | Kraken2, Bracken |
| Bos taurus reference genome | ~3 GB | Minimap2, Bowtie2 |

## Quick Start
