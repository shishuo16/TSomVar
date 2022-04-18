# TSomVar
 a tumor-only somatic variant detection method
## Background
Somatic variants act as key players during cancer occurrence and development, thus an accurate and robust method to identify them is the foundation in the cutting-edge cancer genome research. However, due to low accessibility and high individual-/sample-specificity of the somatic variants in tumor samples, the detection is, to date, still crammed with challenges, particularly when there are no paired normal samples as control. To solve this burning issue, we developed a tumor-only somatic and germline variant identification method (TSomVar), using the random forest algorithm established on sample-specific variant datasets derived from genotype imputation, reads-mapping level annotation and functional annotation.
## Installation
### Requirements
#### Application
* [Annovar](https://annovar.openbioinformatics.org/en/latest/)
* [Beagle5.1](https://faculty.washington.edu/browning/beagle/b5_1.html)
* [MosaicForecast](https://github.com/parklab/MosaicForecast)
* [GATK Mutect2](https://gatk.broadinstitute.org/hc/en-us/articles/360037593851-Mutect2)
* [Python 3.6](https://www.python.org/downloads/)
* [Python module: Numpy](https://numpy.org/)
* [Python module: sklearn](https://scikit-learn.org/stable/)
#### Database (Note: all database files should be stored at ${TSomVar_path}/database/)
* [Haplotype reference panel of the 1000 Genomes Project](http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502)
* [Plink format genetic map](http://bochet.gcc.biostat.washington.edu/beagle/genetic_maps/)
* [Annovar database: avsnp147, cadd, dbnsfp33a, eigen, icgc21, nci60, snp138NonFlagged](https://annovar.openbioinformatics.org/en/latest/)
* [human.fa](https://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/)
```
### database process
### hg19.fa
sed -i 's/^>chr/>/' hg19.fa
samtools faidx hg19.fa ##generate index file .fai
Picard CreateSequenceDictionary REFERENCE=hg19.fa OUTPUT=hg19.fa ##generate index file .dict
```

## Running
```
./TSomVar \
    /path/to/input_Bam  \
    ${sample_id_in_bam} \
    /path/to/TSomVar \
    /path/to/table_annovar.pl(annovar) \
    /path/to/beagle.18May20.d20.jar \
    /path/to/ReadLevel_Features_extraction.py(MosaicForecast) \
    /path/to/k24.umap.wg.bw(MosaicForecast) \
    /path/to/gatk \
    /path/to/hg19.fa \
    ${prefix} \
```
## Output
- ${prefix}.result
  - variant and its classification: germline, uncertain, or somatic
- ${prefix}.result.prob
  - probability matrix of classification of variant
## Maintainers
[@shishuo16](https://github.com/shishuo16)
## Citations
To be continued ...
