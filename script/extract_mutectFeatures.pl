#! /usr/bin/perl -w

use FindBin qw($Bin $Script);
use Getopt::Std;
use File::Path;
use File::Spec;
our %opts = (n=>'0',c=>'N');
getopts('f:s:o:',\%opts);

die "perl $0
          STD  output
          -f   <mutect2 vcf file>
          -s   <selected snp bed file>
          -o   output mutect2 info file\n" unless ($opts{'f'} && $opts{'s'} && $opts{'o'});
$opts{'o'}  = File::Spec->rel2abs($opts{'o'});
my %included;
open IN,"$opts{'s'}" or die $!;
while (my $line=<IN>){
    chomp($line);
    $included{$line}=1;
}
close IN;
open OUT,">$opts{'o'}" or die $!;
print OUT "Chr\tPos\tRef\tAlt\tAD_alt\tAD_ref\tAF_ref\tECNT\tMBQ\tMBQ.1\tMFRL\tMMQ\tMutect2_bad_haplotype\tMutect2_mapping_quality\tMutect2_PASS\tMutect2_t_lod\tSA_POST_PROB\tSA_POST_PROB.1\tSA_POST_PROB.2\n";
open IN,"$opts{'f'}" or die $!;
while (my $line=<IN>){
    next if $line=~/^#/;
    chomp($line);
    my @arr=split(/\t/,$line);
    next unless $included{"$arr[0]\t$arr[1]\t$arr[1]\t$arr[3]\t$arr[4]"};
    my @filter=split(/;/, $arr[6]);
    my %F;
    $F{"bad_haplotype"}="0";
    $F{"mapping_quality"}="0";
    $F{"PASS"}="0";
    $F{"t_lod"}="0";
    foreach(@filter){
        $F{$_}="1";
    }
    my $ecnt=(split(/;/, $arr[7]))[1];
    $ecnt=~s/ECNT=//;
    my @info=split(/:|,/, $arr[9]);
    my $ad_ref=$info[1];
    my $ad_alt=$info[2];
    my $af_ref=$info[3];
    my $mbq=$info[8];
    my $mbq1=$info[9];
    my $mfrl=$info[10];
    my $mmq=$info[12];
    my $SA_POST_PROB=$info[$#info-2];
    my $SA_POST_PROB1=$info[$#info-1];
    my $SA_POST_PROB2=$info[$#info];
    print OUT "$arr[0]\t$arr[1]\t$arr[3]\t$arr[4]\t$ad_alt\t$ad_ref\t$af_ref\t$ecnt\t$mbq\t$mbq1\t$mfrl\t$mmq\t".$F{"bad_haplotype"}."\t".$F{"mapping_quality"}."\t".$F{"PASS"}."\t".$F{"t_lod"}."\t$SA_POST_PROB\t$SA_POST_PROB1\t$SA_POST_PROB2\n";
}
close IN;
close OUT;
