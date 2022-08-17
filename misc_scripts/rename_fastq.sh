for a in $(ls *_paired.fq.gz)
do
	m=$(echo -n $a | perl -p -e 's/_forward_paired.fq.gz/_R1.fastq.gz/; s/_reverse_paired.fq.gz/_R2.fastq.gz/')
	echo "$a -> $m"
	mv $a $m
done
