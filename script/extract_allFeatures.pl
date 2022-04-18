#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Std;
use File::Path;
use File::Spec;
use FindBin qw($Bin $Script);
our %opts = (n=>'0',c=>'N');
getopts('f:o:',\%opts);

die "perl $0
          STD  output
          -f   <imputed vcf file prefix>
          -o   output mutect2 info file\n" unless ($opts{'f'} && $opts{'o'});
$opts{'o'}  = File::Spec->rel2abs($opts{'o'});
my @head=("AD_alt","AD_ref","AF_ref","alt_baseq1b_p","avsnp147","baseq_p","CADD_Phred","COSMIC_C","dp_diff","ECNT","Eigen","Eigen-raw","FATHMM_score","GCcontent","GERP++_RS","ICGC_Id","Impute","major_mismatches_mean","mappability","mapq_difference","mapq_p","MBQ","MBQ.1","M-CAP_rankscore","M-CAP_score","MetaLR_score","MFRL","minor_mismatches_mean","mismatches_p","MMQ","mosaic_likelihood","MutationAssessor_score","Mutect2_bad_haplotype","Mutect2_mapping_quality","Mutect2_PASS","Mutect2_t_lod","nci60","phyloP100way_vertebrate","phyloP20way_mammalian","PROVEAN_score","querypos_p","ref_baseq1b_p","refhom_likelihood","SA_POST_PROB","SA_POST_PROB.1","SA_POST_PROB.2","sb_p","sb_read12_p","seqpos_p","snp138NonFlagged","TCGA","VEST3_score");
my @index=();
my @trans1=(6,10,11,12,14,23,24,25,31,36,37,38,39,51);
my @trans2=(4,15,49);
open OUT,">$opts{o}" or die $!;
open IN1,"$opts{f}" or die $!;
my $features=<IN1>;
my @F=split(/\t/, $features);
foreach(@head){
    foreach my $f(0..$#F){
        if($F[$f] eq $_){
            #print "$_\t$F[$f]\n";
            push @index, $f;
            last;
        }
    }
}
#my $out_line=join("\t",@F[@index]);
#print OUT "$out_line\n";
while (my $line=<IN1>){
    chomp($line);
    my @arr=split(/\t/, $line);
    my @new_arr=@arr[@index];
    foreach(@trans1){
        if($new_arr[$_] eq "."){
            $new_arr[$_]=0;     
        }
    }
    foreach(@trans2){
        if($new_arr[$_] eq "."){
            $new_arr[$_]=0;     
        }else{
            $new_arr[$_]=1;     
        }
    }
    my $out_line=join("\t",@new_arr);
    print OUT "$out_line\n";
}
close IN1;
close OUT;
