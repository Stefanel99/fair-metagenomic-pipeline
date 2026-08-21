echo "Loading the modules..."
module load minimap
module load samtools
module load seqtk
module load emboss
echo " Modules loaded !"

echo "Started the mapping against Bos Taurus..."
for reads in $(ls /proj/rumen_interaction/NOBACKUP/results/Nanopore/chopper/*.fastq)
do
 reads_name=$(echo $reads | cut -d’/’ -f8 | cut -d’.’ -f1)

minimap2 -t 12 - ax map - ont /proj/rumen_interaction/NOBACKUP/results/Nanopore/minimap2/indexes/index_taurus.mmi $reads > "/proj/rumen_interaction/NOBACKUP/results/Nanopore/minimap2/results/${reads_name}_taurus.sam"
echo "Mapping finished !"

echo "Extracting the unmapped reads..."

echo "Creating the BAM file..."
samtools view -bS "/proj/rumen_interaction/NOBACKUP/results/Nanopore/minimap2/results/${reads_name}_taurus.sam" > "/proj/rumen_interaction/NOBACKUP/results/Nanopore/minimap2/results/${reads_name}_taurus.bam"
echo "BAM file created !"

echo "Removing the SAM file..."
rm "/proj/rumen_interaction/NOBACKUP/results/Nanopore/minimap2/results/${reads_name}_taurus.sam"
echo "SAM file removed !"

echo "Creating the second SAM file..."
samtools view -f4 "/proj/rumen_interaction/NOBACKUP/results/Nanopore/minimap2/results/${reads_name}_taurus.bam" > "/proj/rumen_interaction/NOBACKUP/results/Nanopore/minimap2/results/U_${reads_name}_taurus.sam"
echo "Second SAM file created !"

echo "Removing the BAM file..."
rm "/proj/rumen_interaction/NOBACKUP/results/Nanopore/minimap2/results/${reads_name}_taurus.bam"
echo "BAM file removed !"

echo "Creating the list of unmapped reads..."
cut - f1 "/proj/rumen_interaction/NOBACKUP/results/Nanopore/minimap2/results/U_${reads_name}_taurus.sam" | sort | uniq > "/proj/rumen_interaction/NOBACKUP/results/Nanopore/minimap2/results/U_${reads_name}_taurus.list"
echo "List created !"

echo "Removing the second SAM file..."
rm "/proj/rumen_interaction/NOBACKUP/results/Nanopore/minimap2/results/U_${reads_name}_taurus.sam"
echo "Seconda SAM file removed !"

echo "Creating the new fastq file..."
seqtk subseq $reads "/proj/rumen_interaction/NOBACKUP/results/Nanopore/minimap2/results/U_${reads_name}_taurus.list" > "/proj/rumen_interaction/NOBACKUP/results/Nanopore/minimap2/results/U_${reads_name}_taurus.fastq"
echo "New fastq file created !"

echo "Removing the list of unmapped reads..."
rm "/proj/rumen_interaction/NOBACKUP/results/Nanopore/minimap2/results/U_${reads_name}_taurus.list"
echo "List of unmapped reads removed !"

echo "Unmapped reads extracted !"
done

echo "Counting the reads after mapping against Bos Taurus..."
for data in $(ls /proj/rumen_interaction/NOBACKUP/results/Nanopore/minimap2/results/*.fastq)
do
data_name=$(echo $data | cut -d’/’ -f9 | cut -d’.’ -f1)
echo $(infoseq $data 2 >/dev/null | awk ’NR >1 ’ | wc -l) : $data_name >> /proj/rumen_interaction/NOBACKUP/results/Nanopore/counting/count_qc_after_mapping_out.txt
done
echo "Counting finished !"
