echo "Loading the modules..."
module load conda
./opt/sw/conda/3/etc/profile.d/conda.sh

module load seqkit
module load emboss
echo "Modules loaded !"

for file in $(ls /proj/rumen_interaction/NOBACKUP/results/Illumina/bowtie2/alignement/*.gz)
do
f_name=$(echo $file | cut -d’/’ -f9 | cut -d’.’ -f1)

echo "Remove the duplicated reads for ${f_name}..."
seqkit rmdup --threads 20 --by-seq --ignore -case $file -o "/proj/rumen_interaction/NOBACKUP/results/Illumina/trim/trim_${f_name}.fastq.gz"
echo "Duplicated reads removed for ${f_name} !"

echo "Removing the unmapped reads, in order to gain more disk space..."
rm $file
echo "Unmapped reads removed !"

echo "Counting the reads for ${f_name}..."
echo $(zcat "/proj/rumen_interaction/NOBACKUP/results/Illumina/trim/trim_${f_name}.fastq.gz" |
grep -c ’^@’) : "trim_${f_name}" >> /proj/rumen_interaction/NOBACKUP/results/Illumina/counting/count_qc_after_dupl.txt
echo "Counting finished !"
done
