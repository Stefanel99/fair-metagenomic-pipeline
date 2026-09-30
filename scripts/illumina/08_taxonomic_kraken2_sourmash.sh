echo "Load Kraken2..."
module load kraken2
echo "Kraken2 loaded !"

input_dir="/proj/rumen_interaction/NOBACKUP/results/Illumina/trim"
output_dir="/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/kraken"


for trim_R1 in $input_dir/*_R1*.fastq.gz;
do
    trim_R2="${trim_R1/_R1/_R2}"
    output_file_templ=$(echo "$trim_R1" | cut -d'/' -f8 | cut -d'.' -f1 | cut -d'_' -f1,2,3)
    echo "These are the forward reads: {$trim_R1}"
    echo "These are the reverse reads: {$trim_R2}"
    echo "This is the output file: {$output_file_templ}"

    echo "Extracting the unclassified reads with Kraken2..."
    kraken2 --db /proj/rumen_interaction/NOBACKUP/genomes/Kraken2/ --threads 20 --paired $trim_R1 $trim_R2 --unclassified-out "/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/kraken/uncl_${output_file_templ}_R#.fastq"
    echo "Reads extracted !"

    echo "Loading sourmash..."
    module load sourmash
    ./opt/sw/conda/3/etc/profile.d/conda.sh
    module load sourmash
    echo "Sourmash loaded !"

    sourmash sketch dna -p k=31,scaled=30000 --name ${output_file_templ} "/proj/rumen_interaction/NOBACKUP/results/Illuminia/taxa_res/kraken/uncl_${output_file_templ}_R1.fastq" "/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/kraken/uncl_${output_file_templ}_R2.fastq" --merge ${output_file_templ} -o "/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/kraken/${output_file_templ}.sig"

    echo "Loadinig emboss..."
    module load emboss
    echo "Emboss loaded !"

    echo "Counting the unclassified reads from Kraken2..."
    f_name=$(echo /proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/kraken/uncl_${output_file_templ}_R*.fastq | cut -d'/' -f9 | cut -d'.' -f1)
    echo $(infoseq "/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/kraken/uncl_${output_file_templ}_R*.fastq" 2> /dev/null | awk 'NR>1' | wc -l) : $f_name >> /proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/kraken/unclassified_reads_count.txt
    echo "Counting done !"
done 


echo "Load FastQC..."
module load conda
module load fastqc
./opt/sw/conda/3/etc/profile.d/conda.sh
echo "FastQC loaded !"

echo "Quality control over the unclassified reads from Kraken2..."
fastqc -t 20 /proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/kraken/*.fastq /proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/kraken/*.fastq -o /proj/rumen_interaction/NOBACKUP/results/Illumina/full_analysis/fastqc_unclassified_reads/
echo "Quality control done !"

echo "Removing the unclassified reads from Kraken2..."
rm -rf /proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/kraken/*.fastq
echo "Unclassified reads removed !"

echo "Load MultiQC..."
module load multiqc
echo "MultiQC loaded !"

echo "Assembling the FastQC reports with MultiQC..."
multiqc /proj/rumen_interaction/NOBACKUP/results/Illumina/full_analysis/fastqc_unclassified_reads/ -o /proj/rumen_interaction/NOBACKUP/results/Illumina/full_analysis/fastqc_unclassified_reads/multiqc/
echo "MultiQC done !"

echo "Loading sourmash..."
module load conda
./opt/sw/conda/3/etc/profile.d/conda.sh
module load sourmash
echo "Sourmash loaded !"


for sig in $(ls /proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/kraken/*.sig);
do
    sig_name=$(echo $sig | cut -d'/' -f9 | cut -d'.' -f1)
    echo "Creating a CSV file..."
    sourmash gather -k 31 $sig /proj/rumen_interaction/NOBACKUP/genomes/GTDB/gtdb-rs207.genomic.k31.zip -o "/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/kraken/${sig_name}_gather.k31.csv"
    echo "CSV file created !"

    echo "Removing the signature file..."`
    rm $sig
    echo "Signature file removed !"

    echo "Creating a KRONA output..."
    sourmash tax metagenome --gather-csv "/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/kraken/$(sig_name).gather.k31.csv" --taxonomy /proj/rumen_interaction/NOBACKUP/genomes/GTDB/gtdb-rs207.taxonomy.with-strain.csv.gz --output-format krona --rank species > "/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/kraken/${sig_name}.krona"
    echo "KRONA output created !"

    echo "Creating a Kreport output..."
    sourmash tax metagenome --gather-csv "/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/kraken/$(sig_name).gather.k31.csv" --taxonomy /proj/rumen_interaction/NOBACKUP/genomes/GTDB/gtdb-rs207.taxonomy.with-strain.csv.gz --output-format kreport > "/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/kraken/${sig_name}.kreport"
    echo "Kreport output created !"

    echo "Removing the CSV file..."
    rm "/proj/rumen_interaction/NOBACKUP/results/Illumina/taxa_res/kraken/${sig_name}.gather.k31.csv"
    echo "CSV file removed !"
done
