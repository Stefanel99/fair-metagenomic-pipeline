echo "Loading Krake2..."
module load conda
./opt/sw/conda/3/etc/profile.d/conda.sh
module load kraken2
echo "Kraken2 loaded !"


echo "Performing the taxonomic classification with Kraken2..."
for file in $(ls /proj/rumen_interaction/NOBACKUP/results/Nanopore/minimap2/results/*.fastq)
do
f_name=$(echo $file | cut -d’/’ -f9 | cut -d’.’ -f1)
kraken2 --db /proj/rumen_interaction/NOBACKUP/genomes/Kraken2/ --threads 12 --output "/proj/rumen_interaction/NOBACKUP/results/Nanopore/kraken2/${f_name}.kraken" --report "/proj/rumen_interaction/NOBACKUP/results/Nanopore/kraken2/${f_name}.kreport " $file
done
echo "Finished the taxonomic classification with Kraken2 !"


echo "Loading Bracken..."
module load bracken
echo "Bracken loaded !"

echo "Continuing the taxonomic classification with Bracken..."
for file in $(ls /proj/rumen_interaction/NOBACKUP/results/Nanopore/kraken2/*.kreport)
do
f_name=$(echo $file | cut -d’/’ -f8 | cut -d’.’ -f1)
bracken -d /proj/rumen_interaction/NOBACKUP/genomes/Kraken2/ -i $file -o "/proj/rumen_interaction/NOBACKUP/results/Nanopore/kraken2/${f_name}.bracken" -l S
done

echo "Finished the taxonomic classification for Kraken2/Bracken !"
