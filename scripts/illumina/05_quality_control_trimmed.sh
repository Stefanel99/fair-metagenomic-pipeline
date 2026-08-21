for file in $(ls /proj/rumen_interaction/NOBACKUP/results/Illumina/trim/*.gz)
do
file_name=$(echo $file | cut -d’/’ -f8 | cut -d’.’ -f1)
echo $(zcat $file | grep -c ’^@’) : $file_name >> /proj/rumen_interaction/NOBACKUP/results/Illumina/counting/count_qc_after_no_dupl.txt
done


echo "Loading fastqc..."
module load conda
module load fastqc
./opt/sw/conda/3/etc/profile.d/conda.sh
echo "Fastqc loaded !"

fastqc -t 20 /proj/rumen_interaction/NOBACKUP/results/Illumina/trim/*.gz -o /proj/rumen_interaction/NOBACKUP/results/Illumina/full_analysis/fastqc_trim_rep/

echo "Loading multiqc..."
module load multiqc
echo "Multiqc loaded !"

multiqc /proj/rumen_interaction/NOBACKUP/results/Illumina/full_analysis/fastqc_trim_rep/ -o /proj/rumen_interaction/NOBACKUP/results/Illumina/full_analysis/fastqc_trim_rep/multiqc
