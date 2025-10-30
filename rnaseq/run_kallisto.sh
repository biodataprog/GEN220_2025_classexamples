#!/usr/bin/bash -l
#SBATCH -c 16 --mem 16gb --logs logs/kallisto.log

module load kallisto
CPU=16
ln -s /bigdata/gen220/shared/data-examples/rnaseq/kallisto/S_cerevisiae_ORFs.fasta
if [ ! -f Scer.idx ]; then
    kallisto index -i Scer.idx S_cerevisiae_ORFs.fasta
fi
mkdir -p results/kallisto
cat samples.tsv | while read ACC COND REP
do
 OUT=results/kallisto/$COND.$REP
 kallisto quant -t $CPU --single -l 300 -s 20 -i Scer.idx -o $OUT \
 input/${ACC}_1.fastq.gz input/${ACC}_2.fastq.gz
done
