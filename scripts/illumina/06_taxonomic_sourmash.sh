echo "Loading the modules..."
module load conda
./opt/sw/conda/3/etc/profile.d/conda.sh
module load sourmash
echo "Modules loaded !"


input_dir="/proj/rumen_interaction/NOBACKUP/results/Illumina/trim"
output_dir="/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/sourmash/gtdb/pipeline"

for sample_file in $input_dir/*;
do
trim_R1=$(echo "${sample_file}" | grep ’R1’)
trim_R2=$(echo "${sample_file}" | grep ’R2’)
output_file_templ=$(echo ${sample_file} | cut -d’_’ - f4)

echo "Creating the sketches..."
sourmash sketch dna -p k=31 , scaled=30000 --name $output_file_templ $trim_R1 $trim_R2 --merge $output_file_templ -o "/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/sourmash/gtdb/pipeline/${output_file_templ}.sig"
echo "Sketches created !"

echo "Creating a CSV file..."
sourmash gather -k 31 "/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/sourmash/gtdb/pipeline/${output_file_templ}.sig" /proj/rumen_interaction/NOBACKUP/genomes/GTDB/gtdb-rs207.genomic.k31.zip -o "/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/sourmash/gtdb/pipeline/${output_file_templ}.gather.k31.csv"
echo "CSV file created !"

echo "Removing the signature file..."
rm "/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/sourmash/gtdb/pipeline/${output_file_templ}.sig"
echo "Signature file removed !"

echo "Creating a KRONA output..."
sourmash tax metagenome --gather-csv "/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/sourmash/gtdb/pipeline/${output_file_templ}.gather.k31.csv" --taxonomy /proj/rumen_interaction/NOBACKUP/genomes/GTDB/gtdb-rs207.taxonomy.with-strain.csv.gz --output-format krona --rank species > "/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/sourmash/gtdb/pipeline/${output_file_templ}.krona"
echo "KRONA output created !"

echo "Creating a Kreport output..."
sourmash tax metagenome --gather-csv "/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/sourmash/gtdb/pipeline/${output_file_templ}.gather.k31.csv" --taxonomy /proj/rumen_interaction/NOBACKUP/genomes/GTDB/gtdb-rs207.taxonomy.with-strain.csv.gz --output-format kreport > "/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/sourmash/gtdb/pipeline/${output_file_templ}.kreport"
echo "Kreport output created !"

echo "Removing the CSV file..."
rm "/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/sourmash/gtdb/pipeline/${output_file_templ}.gather.k31.csv"
echo "CSV file removed !"
done
