#1 mutect2 vcf file   
#2 output prefix
#3 ToSomVar path
#4 Beagle tool path
#5 selected snp bed file

perl $3/script/generate_vcf4impute.pl -f $1 -d $3/database  -o $2.forimpt.vcf

echo -e "\t==>Imputation start ..."
for chr in $(seq 1 22)
do
    less $2.forimpt.vcf | awk '$1=='${chr}' || $1~/^#/{print}' > $2.forimpt.chr${chr}.vcf
    j=`grep -v '^#' $2.forimpt.chr${chr}.vcf|wc -l`
    if [ $j -eq 0 ] ; then
      continue
    fi
    echo -e "\t\tChromosome ${chr} is processing ..."
    chr_ref=`ls $3/database/ALL.chr${chr}.*.vcf.gz`
    java -Xmx8g -jar $4 gt=$2.forimpt.chr${chr}.vcf ref=${chr_ref} out=$2.chr${chr} map=$3/database/plink.chr${chr}.GRCh37.map nthreads=5 gp=true
done
echo -e "\tImputation is done!"
perl $3/script/extract_imputeFeatures.pl -f $2 -s $5 -o $2.impu.features
