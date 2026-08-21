for file in $(ls /proj/rumen_interaction/data/boran_rumen/Illumina/Sample_WD-3658-*/*)
do
file_name=$(echo $file | cut -d’/’ -f8 | cut -d’.’ -f1 | cut -d’-’ -f3 | cut -d’_’ -f1)
echo $(zcat $file | grep -c ’^@’) : $file_name >> /proj/rumen_interaction/NOBACKUP/results/Illumina/counting/raw_count.txt
done

echo "Loading FastQC..."
module load conda
./opt/sw/conda/3/etc/profile.d/conda.sh
module load fastqc
echo "FastQC loaded !"

fastqc -t 12 /proj/rumen_interaction/data/boran_rumen/Illumina/Sample_WD-3658-*/*.gz -o /proj/rumen_interaction/NOBACKUP/results/Illumina/full_analysis/fastqc_raw_rep/

echo "Loading MultiQC..."
module load multiqc
echo "MultiQC loaded !"


echo "Assemblying all the reports with MultiQC..."
multiqc /proj/rumen_interaction/NOBACKUP/results/Illumina/full_analysis/fastqc_raw_rep/ -o /proj/rumen_interaction/NOBACKUP/results/Illumina/full_analysis/fastqc_raw_rep/multiqc/
echo "Job done !"
