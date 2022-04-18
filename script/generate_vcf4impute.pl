#!/usr/bin/perl
use Getopt::Std;
use File::Path;
use File::Spec;
use FindBin qw($Bin $Script);
getopts('f:d:o:',\%opts);

die "perl $0
          -f   <mutect2 vcf file>
          -d   <database path>  
          -o   output mutect2 info file\n" unless ($opts{'f'} && $opts{'d'} && $opts{'o'});
$opts{'o'}  = File::Spec->rel2abs($opts{'o'});
my %newarr;
my %cosmic;
my %cosmic_nc;
my %tcga;
my %kg;
open IN,"$opts{'f'}" or die $!;
while (my $line=<IN>){
    next if $line=~/^#/;
    chomp($line);
    my @arr=split(/\t/,$line);
    $newarr{"$arr[0]\t$arr[1]\t$arr[3]\t$arr[4]"}=1;
}
close IN;
#whether exist in COSMIC coding
open IN,"gzip -dc $opts{'d'}/CosmicCodingMuts.vcf.4c.gz|" or die $!;
while (my $line=<IN>){
    chomp($line);
    next unless $newarr{$line};
    $cosmic{$line}=1;
}
close IN;
#whether exist in COSMIC noncoding
open IN,"gzip -dc $opts{'d'}/CosmicNonCodingVariants.vcf.4c.gz|" or die $!;
while (my $line=<IN>){
    chomp($line);
    next unless $newarr{$line};
    $cosmic_nc{$line}=1;
}
close IN;
#whether exist in TCGA
open IN,"gzip -dc $opts{'d'}/TCGA_union_somatic.vcf.4c.gz|" or die $!;
while (my $line=<IN>){
    chomp($line);
    next unless $newarr{$line};
    $tcga{$line}=1;
}
close IN;
#whether exist in 1000 genomes
open IN,"gzip -dc $opts{'d'}/1000G_phase3_AFover005.vcf.4c.gz|" or die $!;
while (my $line=<IN>){
    chomp($line);
    next unless $newarr{$line};
    $kg{$line}=1;
}
close IN;

open OUT,">$opts{'o'}" or die $!;
open IN,"$opts{'f'}" or die $!;
while (my $line=<IN>){
    if($line=~/^#/){
        print OUT $line;
        next;
    }
    chomp($line);
    my @arr=split(/\t/,$line);
    next if $arr[4]=~/,/;
    next unless $kg{"$arr[0]\t$arr[1]\t$arr[3]\t$arr[4]"};
    next if $cosmic{"$arr[0]\t$arr[1]\t$arr[3]\t$arr[4]"} || $cosmic_nc{"$arr[0]\t$arr[1]\t$arr[3]\t$arr[4]"} || $tcga{"$arr[0]\t$arr[1]\t$arr[3]\t$arr[4]"};
    my @info=split(/:/,$arr[9]);
    my $ref_ad=(split(/,/,$info[1]))[0];
    if($ref_ad==0){
        $info[0]="1/1";
        $arr[9]=join(":",@info);
        my $out_line=join("\t",@arr);
        print OUT "$out_line\n";
    }else{
        print OUT "$line\n";
    }

}
close IN;
close OUT;
