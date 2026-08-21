echo "Loading FastQC..."
module load conda
module load fastqc
./opt/sw/conda/3/etc/profile.d/conda.sh
echo "FastQC loaded !"

mkdir -p /proj/rumen_interaction/NOBACKUP/results/Nanopore/fastq_rep_mapp/

fastqc -t 12 /proj/rumen_interaction/NOBACKUP/results/Nanopore/minimap2/results/*.fastq -o /proj/rumen_interaction/NOBACKUP/results/Nanopore/fastq_rep_mapp/

echo "Loading MultiQC..."
module load multiqc
echo "MultiQC loaded !"

echo "Assemblying all the reports with MultiQC..."
mkdir -p /proj/rumen_interaction/NOBACKUP/results/Nanopore/fastq_rep_mapp/multiqc/

multiqc /proj/rumen_interaction/NOBACKUP/results/Nanopore/fastq_rep_mapp/ -o /proj/rumen_interaction/NOBACKUP/results/Nanopore/fastq_rep_mapp/multiqc/
echo "Job done!"
