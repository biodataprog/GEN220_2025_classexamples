#!/usr/bin/bash -l
#SBATCH -p short -c 24 --mem 16gb --out pfam_run.log

CPU=24
module load hmmer
module load db-pfam

for orgfile in $(ls *.faa)
do
	name=$(basename $orgfile .faa)
	hmmscan --cpu $CPU --cut_ga --domtblout $name.domtbl $PFAM_DB/Pfam-A.hmm $orgfile > $name.hmmscan
done
