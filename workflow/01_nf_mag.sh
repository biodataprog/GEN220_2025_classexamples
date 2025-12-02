#!/usr/bin/bash -l
#SBATCH --time 7-0:00:00 -c 2 --mem 4gb --out logs/nf_mag.log
module load singularity

CPU=16
if [[ ! -z $SLURM_CPUS_ON_NODE ]]; then
	CPU=$SLURM_CPUS_ON_NODE
fi
PPLACER_CPU=4
nextflow run nf-core/mag -profile singularity --input samplesheet.csv --outdir results/nf_mag -r 4.0.0 \
	--gtdb_db /srv/projects/db/gtdbtk/226 --gtdb_mash /srv/projects/db/gtdbtk/226/mashdb.msh \
	--cat_db /srv/projects/db/CAT/CAT_prepare_20210107 \
	--gunc_db /srv/projects/db/GUNC/gunc_db_progenomes2.1.dmnd \
	--metaeuk_db /srv/projects/db/ncbi/mmseqs/uniref50 \
	--gtdb_mash /srv/projects/db/gtdbtk/226/mashdb.msh \
	--gtdbtk_pplacer_useram \
	--gtdbtk_pplacer_cpus $PPLACER_CPU \
	--skip_spades --refine_bins_dastool \
	--postbinning_input both \
	--run_gunc \
	--metabat_rng_seed 13 \
	--fastp_trim_polyg  -resume -c ucr_hpcc.config
	#--kraken2_db /srv/projects/db/kraken2/pluspfp \
	#--run_virus_identification \
	#--genomad_db /srv/projects/db/genomad/1.9/genomad_db \
	#--genomad_splits 16 --skip_spades \


