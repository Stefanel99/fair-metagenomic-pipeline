echo " Loading FastQC ... "
module load conda
module load fastqc
./opt/sw/conda/3/etc/profile.d/conda.sh
echo "FastQC loaded !"

fastqc -t 12 /proj/rumen_interaction/NOBACKUP/results/Nanopore/chopper/*.fastq -o /proj/rumen_interaction/NOBACKUP/results/Nanopore/fastq_rep_trim/

echo "Loading MultiQC ..."
module load multiqc
echo "MultiQC loaded !"

echo "Assemblying all the reports with MultiQC..."
mkdir -p /proj/rumen_interaction/NOBACKUP/results/Nanopore/fastq_rep_trim/multiqc/
multiqc /proj/rumen_interaction/NOBACKUP/results/Nanopore/fastq_rep_trim/ -o /proj/rumen_interaction/NOBACKUP/results/Nanopore/fastq_rep_trim/multiqc/

echo "Job done !"
