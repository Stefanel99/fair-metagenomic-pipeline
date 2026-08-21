echo "Loading Kraken2..."
module load kraken2
echo "Kraken2 loaded !"

input_dir="/proj/rumen_interaction/NOBACKUP/results/Illumina/trim"
output_dir="/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/k2b"

for trim_R1 in $input_dir/*_R1*.fastq.gz; 
do
trim_R2="${trim_R1/_R1/_R2}" # Substitute R1 with R2 to get the corresponding R2 file
output_file_templ=$(basename " $trim_R1 " | cut -d’_’ -f3 | cut -d’.’ -f1)

echo "Performing the taxonomic classification with Kraken2..."
kraken2 --db /proj/rumen_interaction/NOBACKUP/genomes/Kraken2/ --threads 20 --paired $trim_R1 $trim_R2 --output "${output_dir}/${output_file_templ}.kraken" --report "${output_dir}/${output_file_templ}.kreport"
echo "Finished the taxonomic classification with Kraken2 !"

echo "Loading Bracken..."
module load bracken
echo "Bracken loaded !"

bracken -d /proj/rumen_interaction/NOBACKUP/genomes/Kraken2 -i "${output_dir}/${output_file_templ}.kreport" -o "${output_dir}/${output_file_templ}.bracken" -l S
echo "Finished Bracken for $output_file_templ !"
done
