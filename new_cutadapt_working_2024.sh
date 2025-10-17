#!/bin/bash
#SBATCH --time=01:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=32GB
#SBATCH --job-name=cutadapter
#SBATCH --account=st-jeffrich-1
#SBATCH -o /scratch/st-jeffrich-1/cutadpat/cutadapt.out
#SBATCH -e /scratch/st-jeffrich-1/cutadpat/cutadapt.err

# Load the conda environment
module load miniconda3
source activate /arc/project/st-jeffrich-1/arc/project/st-jeffrich-1/miniconda3/envs/ven_cutadapt

# Change to working directory
cd $SLURM_SUBMIT_DIR

# Cutadapt variables Use NEB Next Adaptors
adaptor1="AGATCGGAAGAGCACACGTCTGAACTCCAGTCA" # remove adapter from read1
adaptor2="AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT" # remove adapter from read2
qcutoff=20

#Determine if the read file includes the R1 character.
#If it does, extract the sample name and R2 file path.
if [[ "$R1" == *"R1"* ]]; then
    sample=$(basename $R1 _R1.fastq.gz)
    R2=$(echo $R1 | sed "s/_R1/_R2/")
else
    echo "ERROR: File path does not appear to contain 'R1'" > /scratch/st-jeffrich-1/${initials}/logs/cutadapt/${sample}.log
    exit 1
fi

# Running cutadapt with arguments
cutadapt --action trim \
--quality-cutoff ${qcutoff} \
-a ${adaptor1} \
-A ${adaptor2} \
--cores 12 \
-o /scratch/st-jeffrich-1/${initials}/clean/${sample}_R1.fastq.gz \
-p /scratch/st-jeffrich-1/${initials}/clean/${sample}_R2.fastq.gz \
${R1} \
${R2} > /scratch/st-jeffrich-1/${initials}/logs/cutadapt/${sample}.log

submitting the job:

for R1 in /arc/project/st-jeffrich-1/RNA_seq_sculpin/cluster/RNA_PS_raw_reads/*_R1.fastq.gz; do 
sbatch --export=R1=${R1},initials=${projectName} cutadapt.sh; 
done