# Cutadapt
This script aims for removing the NEB primers and short sequences.
To submit the script for pair-end sequencing, do:

for R1 in /arc/project/st-jeffrich-1/RNA_seq_sculpin/cluster/RNA_PS_raw_reads/*_R1.fastq.gz; do 
sbatch --export=R1=${R1},initials=${projectName} cutadapt.sh; 
done