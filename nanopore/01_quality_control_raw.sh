echo "Loading FastQC..."
module load conda
module load fastqc
./opt/sw/conda/3/etc/profile.d/conda.sh
echo "FastQC loaded !"

fastqc -t 12 /proj/rumen_interaction/data/boran_rumen/Nanopore/Run_*.fastq -o /proj/rumen_interaction/NOBACKUP/results/Nanopore/fastq_rep/

echo "Loading MultiQC..."
module load multiqc
echo "MultiQC loaded !"


echo "Assemblying all the reports with MultiQC..."
mkdir -p /proj/rumen_interaction/NOBACKUP/results/Nanopore/fastq_rep/multiqc/

multiqc /proj/rumen_interaction/NOBACKUP/results/Nanopore/fastq_trim/ -o /proj/rumen_interaction/NOBACKUP/results/Nanopore/fastq_rep/multiqc/

echo "Job done !"
