#!/usr/bin/bash -l
#SBATCH -p short -c 2

module load hmmer
module load db-pfam

hmmscan --domtblout MET12.domtbl $PFAM_DB/Pfam-A.hmm MET12.fa  > MET12.hmmscan
