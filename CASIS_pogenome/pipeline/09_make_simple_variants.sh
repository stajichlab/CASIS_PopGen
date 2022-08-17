#!/usr/bin/bash -l
#SBATCH -p short 

module load bcftools
module load vcftools
bcftools view -e 'AF=1' vcf/*.All.SNP.combined_selected.vcf.gz | vcf-to-tab | sort -k1,1 | uniq > vcf/SNP_variants.tsv
bcftools view -e 'AF=1' vcf/*.All.INDEL.combined_selected.vcf.gz | vcf-to-tab | sort -k1,1 | uniq > vcf/INDEL_variants.tsv
cat vcf/SNP_variants.tsv vcf/INDEL_variants.tsv | sort -k1,1 | uniq > vcf/all_variants.tsv
