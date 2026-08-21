echo "Loading Kraken2..."
module load conda
./opt/sw/conda/3/etc/profile.d/conda.sh
module load kraken2
echo "Kraken2 loaded !"

for file in $(ls /proj/rumen_interaction/NOBACKUP/results/Nanopore/minimap2/results/*.fastq)
do
f_name=$(echo $file | cut -d’/’ -f9 | cut -d’.’ -f1)
echo "Extracting the unclassified reads with Kraken2..."
kraken2 --db /proj/rumen_interaction/NOBACKUP/genomes/Kraken2/ --threads 12 --unclassified -out "/proj/rumen_interaction/NOBACKUP/results/Nanopore/k2_sourmash/uncl_${f_name}.fastq" $file
echo "Unclassified reads extracted !"
done


echo "Loading the sourmash..."
module load conda
./opt/sw/conda/3/etc/profile.d/conda.sh
module load sourmash
echo "sourmash loaded !"

for file in $(ls /proj/rumen_interaction/NOBACKUP/results/Nanopore/k2_sourmash/*.fastq)
do
f_name=$(echo $file | cut -d’/’ -f8 | cut -d’.’ -f1)
echo "Creating the sketches..."
sourmash sketch dna $file -p k=31 , scaled=100000 --name "${f_name}" -o "/proj/rumen_interaction/NOBACKUP/results/Nanopore/k2_sourmash/${f_name}.sig"
echo "Sketches created !"

echo "Creating a CSV file..."
sourmash gather -k 31 "/proj/rumen_interaction/NOBACKUP/results/Nanopore/k2_sourmash/${f_name}.sig" /proj/rumen_interaction/NOBACKUP/genomes/GTDB/gtdb-rs207.genomic.k31.zip -o "/proj/rumen_interaction/NOBACKUP/results/Nanopore/k2_sourmash/${f_name}.gather.k31.csv"
echo "CSV file created !"

echo "Removing the signature file ..."
rm "/proj/rumen_interaction/NOBACKUP/results/Nanopore/k2_sourmash/${f_name}.sig"
echo "Signature file removed !"

echo "Creating a KRONA output..."
sourmash tax metagenome --gather -csv "/proj/rumen_interaction/NOBACKUP/results/Nanopore/k2_sourmash/${f_name}.gather.k31.csv" --taxonomy /proj/rumen_interaction/NOBACKUP/genomes/GTDB/gtdb-rs207.taxonomy.with-strain.csv.gz --output -format krona --rank species > "/proj/rumen_interaction/NOBACKUP/results/Nanopore/k2_sourmash/${f_name}.krona"
echo "KRONA output created !"

echo "Creating a Kreport output..."
sourmash tax metagenome --gather -csv "/proj/rumen_interaction/NOBACKUP/results/Nanopore/k2_sourmash/${f_name}.gather.k31.csv" --taxonomy /proj/rumen_interaction/NOBACKUP/genomes/GTDB/gtdb-rs207.taxonomy.with-strain.csv.gz --output -format kreport > "/proj/rumen_interaction/NOBACKUP/results/Nanopore/k2_sourmash/${f_name}.kreport"
echo "Kreport output created !"

echo "Removing the CSV file..."
rm "/proj/rumen_interaction/NOBACKUP/results/Nanopore/k2_sourmash/${f_name}.gather.k31.csv"
echo "CSV file removed !"
done



