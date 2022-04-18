#!/usr/bin/perl
use Getopt::Std;
use File::Path;
use File::Spec;
use FindBin qw($Bin $Script);
getopts('f:d:o:',\%opts);

die "perl $0
          -f   <snp bed file>
          -d   <database path>
          -o   output mutect2 info file\n" unless ($opts{'f'} && $opts{'d'} && $opts{'o'});
$opts{'o'}  = File::Spec->rel2abs($opts{'o'});
my %newarr;
my %cosmic;
my %tcga;
open IN,"$opts{'f'}" or die $!;
while (my $line=<IN>){
    chomp($line);
    my @arr=split(/\t/,$line);
    $newarr{"$arr[0]\t$arr[1]\t$arr[3]\t$arr[4]"}=1;
    $cosmic{"$arr[0]\t$arr[1]\t$arr[3]\t$arr[4]"}="0";
    $tcga{"$arr[0]\t$arr[1]\t$arr[3]\t$arr[4]"}="0";
}
close IN;
#whether exist in COSMIC coding
open IN,"$opts{'d'}/CosmicCodingMuts.vcf.4c" or die $!;
while (my $line=<IN>){
    chomp($line);
    next unless $newarr{$line};
    $cosmic{$line}=1;
}
close IN;
#whether exist in TCGA
open IN,"$opts{'d'}/TCGA_union_somatic.vcf.4c" or die $!;
while (my $line=<IN>){
    chomp($line);
    next unless $newarr{$line};
    $tcga{$line}=1;
}
close IN;

open OUT,">$opts{'o'}" or die $!;
print OUT "Chr\tPos\tRef\tAlt\tCOSMIC_C\tTCGA\n";
open IN,"$opts{'f'}" or die $!;
while (my $line=<IN>){
    chomp($line);
    my @arr=split(/\t/,$line);
    print OUT "$arr[0]\t$arr[1]\t$arr[3]\t$arr[4]\t".$cosmic{"$arr[0]\t$arr[1]\t$arr[3]\t$arr[4]"}."\t".$tcga{"$arr[0]\t$arr[1]\t$arr[3]\t$arr[4]"}."\n";
}
close IN;
close OUT;
