#!/usr/bin/bash -l
#SBATCH -p short -N 1 -n 1 -a 2-8 --out logs/setup.%a.log
N=${SLURM_ARRAY_TASK_ID}

if [ -z $N ]; then
    N=$1
    if [ -z $N ]; then
        echo "Need an array id or cmdline val for the job"
        exit
    fi
fi


IFS=,
TEMPLATE=CASIS_pogenome
SAMPLES=samples.csv
RUNDIR=strain_analysis
REFDIR=ref_genomes
RESEQ=reseq_data
mkdir -p $RUNDIR
cat $SAMPLES | sed -n ${N}p | while read NAME REFGENOME SPECIES
do
	echo "NAME=$NAME"
	echo "REF=$REFGENOME"
	mkdir -p $RUNDIR/$NAME/genome
	ln -s $(realpath $REFDIR/$REFGENOME) $RUNDIR/$NAME/genome/$NAME.fasta
	perl -p -e "s/REFGENOME=.+/REFGENOME=genome\/$NAME.fasta/" $TEMPLATE/config.txt >  $RUNDIR/$NAME/config.txt
	perl -i -p -e "s/GENOMENAME=.+/GENOMENAME=$NAME/" $RUNDIR/$NAME/config.txt
	perl -i -p -e "s/PREFIX=.+/PREFIX=CASIS_$NAME/" $RUNDIR/$NAME/config.txt
	realpath $RESEQ/$NAME
	echo "$RUNDIR/$NAME/input"
	ln -s $(realpath $RESEQ/$NAME) $RUNDIR/$NAME/input
	pushd $RUNDIR/$NAME
	mkdir -p logs
	bash ../../CASIS_pogenome/pipeline/00_index.sh
	bash ../../CASIS_pogenome/scripts/make_samples_file.sh
	bash ../../CASIS_pogenome/scripts/make_populations.sh
	popd
done
