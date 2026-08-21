echo " Loading the modules ... "
module load conda
./opt/sw/conda/3/etc/profile.d/conda.sh
module load sourmash
echo "Modules loaded !"

for file in $(ls /proj/rumen_interaction/NOBACKUP/results/Nanopore/minimap2/results/*.fastq)
do
f_name=$(echo $file | cut -d’/’ -f9 | cut -d’.’ -f1)
echo "Creating the sketches..."
sourmash sketch dna $file -p k=31 , scaled=100000 --name "${f_name}" -o "/proj/rumen_interaction/NOBACKUP/results/Nanopore/sourmash/GTDB/pipeline/${f_name}.sig"
echo "Sketches created !"

echo "Creating a CSV file..."
sourmash gather -k 31 "/proj/rumen_interaction/NOBACKUP/results/Nanopore/sourmash/GTDB/pipeline/${f_name}.sig" /proj/rumen_interaction/NOBACKUP/genomes/GTDB/gtdb-rs207.genomic.k31.zip -o "/proj/rumen_interaction/NOBACKUP/results/Nanopore/sourmash/GTDB/pipeline/${f_name}.gather.k31.csv"
echo "CSV file created !"

echo "Removing the signature file..."
rm "/proj/rumen_interaction/NOBACKUP/results/Nanopore/sourmash/GTDB/pipeline/${f_name}.sig"
echo "Signature file removed !"

echo "Creating a KRONA output..."
sourmash tax metagenome --gather -csv "/proj/rumen_interaction/NOBACKUP/results/Nanopore/sourmash/GTDB/pipeline/${f_name}.gather.k31.csv" --taxonomy /proj/rumen_interaction/NOBACKUP/genomes/GTDB/gtdb-rs207.taxonomy.with-strain.csv.gz --output -format krona --rank species > "/proj/rumen_interaction/NOBACKUP/results/Nanopore/sourmash/GTDB/pipeline/${f_name}.krona"
echo "KRONA output created !"

echo "Creating a Kreport output..."
sourmash tax metagenome --gather -csv "/proj/rumen_interaction/NOBACKUP/results/Nanopore/sourmash/GTDB/pipeline/${f_name}.gather.k31.csv" --taxonomy /proj/rumen_interaction/NOBACKUP/genomes/GTDB/gtdb-rs207.taxonomy.with-strain.csv.gz --output -format kreport > "/proj/rumen_interaction/NOBACKUP/results/Nanopore/sourmash/GTDB/pipeline/${f_name}.kreport"
echo "Kreport output created !"

echo "Removing the CSV file..."
rm "/proj/rumen_interaction/NOBACKUP/results/Nanopore/sourmash/GTDB/pipeline/${f_name}.gather.k31.csv"
echo "CSV file removed !"
done
