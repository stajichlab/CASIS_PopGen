#!/usr/bin/bash -l
#SBATCH -p short 

module load bcftools
module load vcftools
bcftools view -e 'AF=1' vcf/*.All.SNP.combined_selected.vcf.gz | vcf-to-tab | sort -k1,1 | uniq > vcf/SNP_variants.tab
bcftools view -e 'AF=1' vcf/*.All.INDEL.combined_selected.vcf.gz | vcf-to-tab | sort -k1,1 | uniq > vcf/INDEL_variants.tab
cat vcf/SNP_variants.tab vcf/INDEL_variants.tab | sort -k1,1 | uniq > vcf/all_variants.tab
