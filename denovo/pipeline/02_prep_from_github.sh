#!/usr/bin/bash -l
#SBATCH -p short

pigz -dk asm/denovo/*.sorted.fasta.gz
