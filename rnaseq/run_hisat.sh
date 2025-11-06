#!/usr/bin/bash -l
#SBATCH -c 16 --mem 16gb --out logs/hisat.%a.log
module load hisat2
module load samtools
module load fastp
CPU=16
SAMPLES=samples.tsv
mkdir -p trimmed
N=$SLURM_ARRAY_TASK_ID
if [ -z $N ]; then
    echo "No N was found"
    N=$1
    if [ -z $N ]; then
        echo 'No command line info either, quitting'
        exit
    fi
fi
sed -n ${N}p $SAMPLES | while read SRA TREATMENT REPLICATE
do
    # read filtering
    date
    time fastp -i input/${SRA}_1.fastq.gz -I input/${SRA}_2.fastq.gz \
        -o trimmed/${SRA}_1.fastq.gz -O trimmed/${SRA}_2.fastq.gz --thread $CPU
    time hisat2  -x yeast -1 trimmed/${SRA}_1.fastq.gz \
        -2  trimmed/${SRA}_2.fastq.gz \
        -S results/hisat/${SRA}.sam -p $CPU
    samtools sort -O BAM -o results/hisat/${SRA}.bam results/hisat/${SRA}.sam
    date
done