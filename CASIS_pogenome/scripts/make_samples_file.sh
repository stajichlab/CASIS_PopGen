#!/usr/bin/bash -l
echo "STRAIN,FILEBASE" > samples.csv
FILE=$(realpath samples.csv)
pushd input
ls *R1.fastq.gz | perl -p -e 's/((\S+)_R1\.fastq\.gz)/$2,$2_R[12].fastq.gz/' >> $FILE
