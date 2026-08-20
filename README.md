# FAIR-Compliant Metagenomics Analysis Pipeline

Automated and reproducible pipeline for shotgun metagenomics analysis of Nanopore and Illumina sequencing data, developed following FAIR principles: Findable, Accessible, Interoperable, and Reusable.

This repository contains the code and documentation from my Bachelor's thesis:

**“Automatise the process for metagenomics analysis of reads FAIR compliant”**

The pipeline was developed during my internship at SLU, Swedish University of Agricultural Sciences, and was applied to rumen metagenomic sequencing data from Ethiopian Boran cattle.

---

## Overview

This project focuses on building a FAIR-compliant bioinformatics pipeline for metagenomic read analysis. The workflow processes raw sequencing reads, performs quality control, removes host DNA, classifies microbial reads taxonomically, and generates outputs for downstream visualization and interpretation.

The pipeline supports two sequencing technologies:

- Oxford Nanopore sequencing
- Illumina paired-end sequencing

The biological use case was the analysis of rumen microbiome composition in Ethiopian Boran cattle across different seasons.

---

## Biological Context

The rumen microbiome plays an important role in cattle digestion, feed efficiency, methane production, and adaptation to environmental conditions.

This project analyzed metagenomic sequencing data from Ethiopian Boran cattle rumen samples. The Ethiopian Boran is a hybrid between *Bos indicus* and *Bos taurus*. Since a high-quality Ethiopian Boran reference genome was not available, host DNA removal was performed using the *Bos taurus* reference genome.

The study compared samples collected during different seasonal periods:

- February: dry season
- July: wet season

The aim was to explore how seasonal variation may affect microbial composition in the rumen.

---

## Main Goals

The main goals of this project were:

- Build an automated metagenomics pipeline for Nanopore and Illumina reads
- Apply FAIR principles to make the workflow reusable and understandable
- Perform quality control on raw and processed reads
- Remove host DNA contamination
- Compare taxonomic profiling tools
- Generate outputs compatible with visualization tools
- Document the workflow clearly for future users

---

## Pipeline Summary

The pipeline includes the following major steps:

1. Raw read quality control
2. Read trimming or duplicate removal
3. Host DNA removal
4. Quality control after filtering
5. Taxonomic classification
6. Visualization and summary plotting

The pipeline was implemented mainly using Bash scripts and Python visualization scripts.

---

## Nanopore Workflow

The Nanopore workflow processes long-read FASTQ files.

```text
Raw Nanopore FASTQ
        |
        v
Quality Control
FastQC + MultiQC
        |
        v
Trimming
Chopper
        |
        v
Quality Control After Trimming
FastQC + MultiQC
        |
        v
Host Removal
Minimap2 + Samtools + Seqtk
        |
        v
Quality Control After Host Removal
FastQC + MultiQC
        |
        v
Taxonomic Profiling
sourmash / Kraken2 + Bracken / Kraken2 + sourmash
        |
        v
Visualization
Krona / Pavian / Python plots
```

---

## Illumina Workflow

The Illumina workflow processes paired-end compressed FASTQ files.

```text
Raw Illumina FASTQ.gz
        |
        v
Quality Control
FastQC + MultiQC
        |
        v
Host Removal
Bowtie2 + Samtools + Seqtk
        |
        v
Quality Control After Host Removal
FastQC + MultiQC
        |
        v
Duplicate Removal / Trimming
SeqKit
        |
        v
Quality Control After Trimming
FastQC + MultiQC
        |
        v
Taxonomic Profiling
sourmash / Kraken2 + Bracken / Kraken2 + sourmash
        |
        v
Visualization
Krona / Pavian / Python plots
```

For Illumina data, host removal was performed before trimming because Bowtie2 requires paired-end read files to remain synchronized.

---

## Repository Structure

```text
fair-metagenomics-pipeline/
├── README.md
├── LICENSE
├── environment.yml
├── .gitignore
├── config/
│   ├── nanopore_config.sh
│   └── illumina_config.sh
├── scripts/
│   ├── setup/
│   │   ├── install_dependencies.sh
│   │   └── download_databases.sh
│   ├── nanopore/
│   │   ├── 01_quality_control_raw.sh
│   │   ├── 02_trimming.sh
│   │   ├── 03_quality_control_trimmed.sh
│   │   ├── 04_host_removal.sh
│   │   ├── 05_quality_control_unmapped.sh
│   │   ├── 06_taxonomic_sourmash.sh
│   │   ├── 07_taxonomic_kraken2_bracken.sh
│   │   └── 08_taxonomic_kraken2_sourmash.sh
│   ├── illumina/
│   │   ├── 01_quality_control_raw.sh
│   │   ├── 02_host_removal.sh
│   │   ├── 03_quality_control_unmapped.sh
│   │   ├── 04_trimming.sh
│   │   ├── 05_quality_control_trimmed.sh
│   │   ├── 06_taxonomic_sourmash.sh
│   │   ├── 07_taxonomic_kraken2_bracken.sh
│   │   └── 08_taxonomic_kraken2_sourmash.sh
│   └── visualization/
│       ├── plot_reads_data.py
│       ├── plot_phyla_boxplot.py
│       ├── plot_lost_reads.py
│       ├── scatter_reads_vs_species.py
│       └── scatter_classified_vs_species.py
└── docs/
    ├── pipeline_workflow.md
    └── parameter_justification.md
```

---

## Software Requirements

This pipeline was developed and tested in a Linux/HPC environment.

Required tools include:

| Tool | Purpose |
|---|---|
| FastQC | Read quality control |
| MultiQC | Aggregation of quality reports |
| Chopper | Nanopore read trimming |
| SeqKit | Duplicate removal and sequence processing |
| Minimap2 | Host read mapping for Nanopore data |
| Bowtie2 | Host read mapping for Illumina data |
| Samtools | SAM/BAM file processing |
| Seqtk | Extraction of unmapped reads |
| sourmash | MinHash/FracMinHash-based taxonomic profiling |
| Kraken2 | K-mer based taxonomic classification |
| Bracken | Abundance re-estimation from Kraken2 output |
| Krona | Taxonomic visualization |
| Pavian | Visualization of metagenomics classification results |
| EMBOSS infoseq | Read counting |
| Python | Plotting and downstream analysis |

Python libraries used:

| Library | Purpose |
|---|---|
| pandas | Data handling |
| matplotlib | Plotting |
| seaborn | Statistical visualization |
| argparse | Command-line arguments |
| os / sys | File and system operations |

---

## Reference Databases

The pipeline uses the following reference databases:

| Database | Purpose |
|---|---|
| GTDB R07-RS207 | Taxonomic profiling with sourmash |
| GTDB taxonomy file | Taxonomic assignment for sourmash output |
| Kraken2 Standard database | Taxonomic classification with Kraken2 |
| *Bos taurus* reference genome | Host DNA removal |

GTDB was used because it provides a curated and quality-controlled genome taxonomy database, which is useful for metagenomic classification.

The *Bos taurus* reference genome was used for host removal because no specific Ethiopian Boran reference genome was available.

---

## Installation

Clone the repository:

```bash
git clone https://github.com/Stefanel99/fair-metagenomics-pipeline.git
cd fair-metagenomics-pipeline
```

Create the Conda environment:

```bash
conda env create -f environment.yml
conda activate fair-metagenomics
```

Alternatively, install dependencies manually depending on your HPC environment and available modules.

---

## Configuration

Before running the pipeline, edit the configuration files:

```bash
config/nanopore_config.sh
config/illumina_config.sh
```

These files define paths to:

- Input sequencing data
- Output directories
- Reference genomes
- Databases
- Thread counts
- Tool parameters

Example variables:

```bash
DATA_DIR="/path/to/raw/data"
RESULTS_DIR="/path/to/results"
GENOMES_DIR="/path/to/genomes"
THREADS=12
KMER_SIZE=31
```

Using configuration files makes the pipeline easier to reuse on different systems.

---

## Running the Nanopore Pipeline

Run each script sequentially:

```bash
bash scripts/nanopore/01_quality_control_raw.sh
bash scripts/nanopore/02_trimming.sh
bash scripts/nanopore/03_quality_control_trimmed.sh
bash scripts/nanopore/04_host_removal.sh
bash scripts/nanopore/05_quality_control_unmapped.sh
bash scripts/nanopore/06_taxonomic_sourmash.sh
bash scripts/nanopore/07_taxonomic_kraken2_bracken.sh
bash scripts/nanopore/08_taxonomic_kraken2_sourmash.sh
```

---

## Running the Illumina Pipeline

Run each script sequentially:

```bash
bash scripts/illumina/01_quality_control_raw.sh
bash scripts/illumina/02_host_removal.sh
bash scripts/illumina/03_quality_control_unmapped.sh
bash scripts/illumina/04_trimming.sh
bash scripts/illumina/05_quality_control_trimmed.sh
bash scripts/illumina/06_taxonomic_sourmash.sh
bash scripts/illumina/07_taxonomic_kraken2_bracken.sh
bash scripts/illumina/08_taxonomic_kraken2_sourmash.sh
```

---

## Main Pipeline Steps

### 1. Quality Control

Raw sequencing reads are checked using FastQC.

MultiQC is then used to summarize all FastQC reports into a single report.

This step helps identify:

- Read quality distribution
- Adapter contamination
- Sequence length distribution
- GC content
- Overrepresented sequences

---

### 2. Nanopore Trimming

Nanopore reads are trimmed using Chopper.

The main parameter used was:

```bash
-q 10
```

This keeps reads above a Phred quality threshold of 10.

---

### 3. Illumina Duplicate Removal

Illumina reads are processed using SeqKit to remove duplicated reads.

This was done with:

```bash
seqkit rmdup --by-seq --ignore-case
```

Duplicate removal helps reduce redundancy and unnecessary computational load.

---

### 4. Host DNA Removal

Host DNA was removed to retain microbial reads.

For Nanopore data, Minimap2 was used:

```bash
minimap2 -ax map-ont
```

For Illumina data, Bowtie2 was used:

```bash
bowtie2
```

Unmapped reads were extracted using Samtools and Seqtk.

---

### 5. Taxonomic Profiling with sourmash

sourmash was used to create FracMinHash sketches and compare them against GTDB.

Nanopore data used:

```bash
scaled=100000
k=31
```

Illumina data used:

```bash
scaled=30000
k=31
```

sourmash was used because it enables lightweight comparison of large sequencing datasets through sketching.

---

### 6. Taxonomic Profiling with Kraken2 and Bracken

Kraken2 was used for k-mer based taxonomic classification.

Bracken was then used to improve abundance estimation from Kraken2 results.

This combination provided higher classification rates than sourmash alone.

---

### 7. Kraken2 + sourmash Strategy

A combined approach was also tested.

First, Kraken2 was used to extract unclassified reads. Then sourmash was applied to these unclassified reads to determine whether additional taxonomic information could be recovered.

This allowed additional classification beyond Kraken2 alone.

---

## Important Parameters

| Parameter | Nanopore | Illumina |
|---|---|---|
| Host mapper | Minimap2 | Bowtie2 |
| Trimming / filtering tool | Chopper | SeqKit |
| sourmash k-mer size | 31 | 31 |
| sourmash scaling | 100000 | 30000 |
| Taxonomic database | GTDB | GTDB |
| Kraken2 database | Standard Kraken2 DB | Standard Kraken2 DB |
| Host reference | *Bos taurus* | *Bos taurus* |

---

## Outputs

The pipeline generates several output types:

| Output | Description |
|---|---|
| FastQC reports | Quality control reports |
| MultiQC reports | Aggregated QC summaries |
| Trimmed FASTQ files | Filtered reads |
| Unmapped FASTQ files | Reads remaining after host removal |
| sourmash signatures | Sequence sketches |
| sourmash gather CSV files | Taxonomic matches |
| sourmash kreport files | Kraken-style output |
| Kraken2 reports | Taxonomic classification reports |
| Bracken reports | Abundance re-estimation reports |
| Krona files | Interactive visualization input |
| Python plots | Read count and taxonomic summary plots |

---

## Visualization

Python scripts are provided for plotting and summarizing results.

The visualization scripts can be found in:

```text
scripts/visualization/
```

They include:

| Script | Purpose |
|---|---|
| plot_reads_data.py | Plot read counts across samples |
| plot_phyla_boxplot.py | Plot phylum-level abundance distributions |
| plot_lost_reads.py | Plot read loss across pipeline steps |
| scatter_reads_vs_species.py | Scatterplot of reads versus detected species |
| scatter_classified_vs_species.py | Scatterplot of classified reads versus detected species |

Example usage:

```bash
python scripts/visualization/plot_phyla_boxplot.py \
  --directory path/to/krona/files \
  --output phyla_boxplot.png
```

---

## Summary of Results

The pipeline successfully processed Nanopore and Illumina metagenomic data from Ethiopian Boran rumen samples.

Main observations included:

- Kraken2 produced higher classification rates than sourmash alone.
- sourmash provided a lightweight and database-efficient approach.
- Combining Kraken2 and sourmash recovered additional classifications from previously unclassified reads.
- Bacteroidota was one of the dominant phyla detected.
- Methanobacteriaceae were detected and are biologically relevant because of their role in rumen methanogenesis.
- Seasonal variation was observed in microbial composition between February and July samples.

---

## Classification Summary

Approximate classification ranges observed during the project:

| Method | Nanopore | Illumina |
|---|---|---|
| sourmash | Around 7–9% | Around 6–9% |
| Kraken2 | Around 61–85% | Around 63–64% |
| Kraken2 + sourmash | Additional classification recovered | Additional classification recovered |

These values depend on database completeness, sequencing technology, sample composition, and preprocessing steps.

---

## FAIR Compliance

This project was designed according to FAIR principles.

| FAIR Principle | Implementation |
|---|---|
| Findable | Public GitHub repository, clear naming, documented structure |
| Accessible | Open scripts, readable documentation, standard formats |
| Interoperable | FASTQ, SAM/BAM, CSV, KREPORT, Krona-compatible outputs |
| Reusable | Config files, modular scripts, documented parameters |

---

## Testing and Validation

The original pipeline was developed and tested on the SLU HPC cluster.

Because full execution requires large sequencing files and reference databases, this public version is intended as a reusable and documented codebase.

Recommended validation steps:

```bash
# Check Bash syntax
bash -n scripts/nanopore/01_quality_control_raw.sh
bash -n scripts/nanopore/02_trimming.sh
bash -n scripts/nanopore/03_quality_control_trimmed.sh
bash -n scripts/nanopore/04_host_removal.sh
bash -n scripts/nanopore/05_quality_control_unmapped.sh
bash -n scripts/nanopore/06_taxonomic_sourmash.sh
bash -n scripts/nanopore/07_taxonomic_kraken2_bracken.sh
bash -n scripts/nanopore/08_taxonomic_kraken2_sourmash.sh

bash -n scripts/illumina/01_quality_control_raw.sh
bash -n scripts/illumina/02_host_removal.sh
bash -n scripts/illumina/03_quality_control_unmapped.sh
bash -n scripts/illumina/04_trimming.sh
bash -n scripts/illumina/05_quality_control_trimmed.sh
bash -n scripts/illumina/06_taxonomic_sourmash.sh
bash -n scripts/illumina/07_taxonomic_kraken2_bracken.sh
bash -n scripts/illumina/08_taxonomic_kraken2_sourmash.sh

# Check Python syntax
python -m py_compile scripts/visualization/*.py
```

Full reproducibility requires:

- Raw sequencing data
- GTDB database
- Kraken2 database
- *Bos taurus* reference genome
- Linux/HPC or equivalent compute environment

---

## Known Limitations

This pipeline has some limitations:

- It was developed for a specific rumen metagenomics dataset.
- Full execution requires large databases and significant storage.
- sourmash classification rates depend strongly on database completeness.
- The *Bos taurus* reference genome was used as an approximation for Ethiopian Boran host removal.
- Some paths in the original thesis scripts were specific to the SLU HPC environment and must be changed in the config files.
- The current implementation is script-based rather than fully wrapped in Snakemake or Nextflow.

---

## Future Improvements

Potential future improvements include:

- Convert the full workflow to Snakemake or Nextflow
- Add Docker or Singularity containers
- Add automated test data
- Add continuous integration for syntax checks
- Add functional annotation using KEGG, eggNOG, or similar databases
- Add long-read assembly for Nanopore data
- Add support for additional host genomes
- Add more flexible taxonomic database options
- Improve visualization outputs

---

## Citation

If you use or adapt this pipeline, please cite:

```bibtex
@misc{tarnauceanu2024fairmetagenomics,
  title = {Automatise the process for metagenomics analysis of reads FAIR compliant},
  author = {Tarnauceanu, Stefan},
  year = {2024},
  institution = {HEH-Condorcet and Swedish University of Agricultural Sciences},
  note = {Bachelor's thesis}
}
```

---

## Author

**Stefan Tarnauceanu**

MSc Bioinformatics, Swedish University of Agricultural Sciences  
BSc Biotechnology with Bioinformatics focus, HEH-Condorcet  


---

## Acknowledgements

This project was developed during an internship at SLU, Swedish University of Agricultural Sciences.

Supervision and support:

- Prof. Erik Bongcam-Rudloff
- Prof. David Coornaert
- Dr. Renaud Van Damme

The work was part of a broader rumen interaction research project investigating host genome and microbial composition in Ethiopian Boran cattle.

---

## License

This project is released under the MIT License.

See the `LICENSE` file for details.
