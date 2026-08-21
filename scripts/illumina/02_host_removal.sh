echo " Loading bowtie2 ... "
module load bowtie
echo "bowtie2 loaded !"

input_dir="/proj/rumen_interaction/data/boran_rumen/Illumina"
output_dir="/proj/rumen_interaction/NOBACKUP/results/Illumina/bowtie2/alignement"

for sample_dir in $input_dir/Sample_WD-3658-*;
do
  if [ -d "${sample_dir}" ]; then
    fastq_r1=$(echo "${sample_dir}/*_R1_*.fastq.gz")
    fastq_r2=$(echo "${sample_dir}/*_R2_*.fastq.gz")
    sample_date=$(echo $sample_dir | cut -d’/’ -f7 | cut -d’_’ -f2 | cut -d’-’ -f3)
  fi

output_file="${output_dir}/${sample_date}_taurus.sam"

echo "Mapping Bos Taurus against July0407..."
bowtie2 -p 20 -x /proj/rumen_interaction/NOBACKUP/results/Illumina/bowtie2/index_taurus -1
$fastq_r1 -2 $fastq_r2 > $output_file
echo "Mapping finished !"

echo "Extracting the unmapped reads..."

echo "Loading samtools..."
module load samtools
echo "samtools loaded !"

echo "Creating the BAM file..."
samtools view -bS $output_file > "${output_file%.sam}.bam"
echo "BAM file created !"

echo " Removing the SAM file..."
rm $output_file
echo "SAM file removed !"

echo "Creating the second SAM file..."
samtools view -f4 "${output_file%.sam}.bam" > "${output_dir}/unmapped_${sample_date}_taurus.sam"
echo "Second SAM file created !"

echo "Removing the BAM file..."
rm "${output_file%.sam}.bam"
echo "BAM file removed !"

echo "Creating the list of unmapped reads..."
cut - f1 "${output_dir}/unmapped_${sample_date}_taurus.sam " | sort | uniq > "${output_dir}/unmapped_${sample_date}_taurus.list"
echo "List created !"

echo "Removing the second SAM file..."
rm "${output_dir}/unmapped_${sample_date}_taurus.sam"
echo "Second SAM file removed !"


echo "Loading seqtk..."
module load seqtk
echo "seqtk loaded !"

echo "Creating the newly unmapped reads for ${sample_date}..."
seqtk subseq $fastq_r1 "${output_dir}/unmapped_${sample_date}_taurus.list" > "${output_dir}/unmapped_${sample_date}_R1.fastq"
seqtk subseq $fastq_r2 "${output_dir}/unmapped_${sample_date}_taurus.list" > "${output_dir}/unmapped_${sample_date}_R2.fastq"
echo "Reads created for ${sample_date} !"

echo "Counting the reads for unmapped_${sample_date}..."
echo $(infoseq "${output_dir}/unmapped_${sample_date}_R1.fastq" 2 >/dev/null | awk ’NR >1 ’ | wc
-l) : "${sample_date}" >> /proj/rumen_interaction/NOBACKUP/results/Illumina/counting/unmap_count.txt
echo "Finished the counting for unmapped_${sample_date} !"

echo "Zipping the file unmapped_${sample_date}..."
gzip -c "${output_dir}/unmapped_${sample_date}_R1.fastq" > "${output_dir}/unmapped_${sample_date}_R1.fastq.gz"
rm "${output_dir}/unmapped_${sample_date}_R1.fastq"
gzip -c "${output_dir}/unmapped_${sample_date}_R2.fastq" > "${output_dir}/unmapped_${sample_date}_R2.fastq.gz"
rm "${output_dir}/unmapped_${sample_date}_R2.fastq"
echo "Unmapped_${sample_date} zipped !"

echo "Unmapped reads extracted !"

echo "Removing the list of unmapped reads..."
rm "${output_dir}/unmapped_${sample_date}_taurus.list"
echo "List removed !"

done
