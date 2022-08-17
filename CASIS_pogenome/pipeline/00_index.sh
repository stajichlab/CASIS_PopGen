#!/usr/bin/bash -l
module load samtools
module load bwa
if [ -f config.txt ]; then
	source config.txt
fi
FASTAFILE=$REFGENOME
if [[ ! -f $FASTAFILE.fai || $FASTAFILE -nt $FASTAFILE.fai ]]; then
	samtools faidx $FASTAFILE
fi
if [[ ! -f $FASTAFILE.bwt || $FASTAFILE -nt $FASTAFILE.bwt ]]; then
	bwa index $FASTAFILE
fi

DICT=$(basename $FASTAFILE .fasta)".dict"

if [[ ! -f $GENOMEFOLDER/$DICT || $GENOMEFOLDER/$FASTAFILE -nt $GENOMEFOLDER/$DICT ]]; then
	rm -f $GENOMEFOLDER/$DICT
	samtools dict $FASTAFILE > $GENOMEFOLDER/$DICT
	ln -s $DICT $FASTAFILE.dict 
fi
grep ">" $FASTAFILE | perl -p -e 's/>((Chr)?(\d+|mito)_\S+)\s+.+/$1,$3/' > $GENOMEFOLDER/chrom_nums.csv
