 for file in $( ls / proj / rumen_interaction / data / boran_rumen / Illumina / Sample_WD -3658 -*/*)
2 do
3 file_name =$( echo $file | cut -d’/’ -f8 | cut -d’.’ -f1 | cut -d’-’ -f3 | cut -d’_’ -f1 )
4 echo $( zcat $file | grep -c ’^@’) : $file_name >> / proj / rumen_interaction / NOBACKUP / results /
Illumina / counting / raw_count . txt
5 done
6
7 echo " Loading FastQC ... "
8 module load conda
9 . / opt / sw / conda /3/ etc / profile . d/ conda . sh
10 module load fastqc
11 echo " FastQC loaded !"
12
13 fastqc -t 12 / proj / rumen_interaction / data / boran_rumen / Illumina / Sample_WD -3658 -*/*. gz -o / proj /
rumen_interaction / NOBACKUP / results / Illumina / full_analysis / fastqc_raw_rep /
14
15 echo " Loading MultiQC ... "
16 module load multiqc
17 echo " MultiQC loaded !"
18
19
20 echo " Assemblying all the reports with MultiQC ..."
21 multiqc / proj / rumen_interaction / NOBACKUP / results / Illumina / full_analysis / fastqc_raw_rep / -o /
proj / rumen_interaction / NOBACKUP / results / Illumina / full_analysis / fastqc_raw_rep / multiqc /
22 echo " Job done !"
