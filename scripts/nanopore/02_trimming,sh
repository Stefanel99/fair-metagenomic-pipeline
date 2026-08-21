for file in $(ls /proj/rumen_interaction/data/boran_rumen/Nanopore/Run*);
do
file_name=$(echo $file | cut -d’/’ -f7 | cut -d’.’ -f1)

echo "Trimming the ${file} of Nanopore with a Phred score of 10..."
cat $file | chopper -t 12 -q 10 > "/proj/rumen_interaction/NOBACKUP/results/Nanopore/chopper/trimmed_${file_name}.fastq"
echo "Finished trimming !"

echo " Counting the number of reads for ${ file_name }... "
echo $(infoseq "/proj/rumen_interaction/NOBACKUP/results/Nanopore/chopper/trimmed_${file_name}.fastq" 2 >/dev/null | awk ’NR >1 ’ | wc -l) : "trimmed_${file_name}" >> /proj/rumen_interaction/NOBACKUP/results/Nanopore/counting/count_qc_after_trim.txt

echo "Finished counting for ${file_name} !"
done
