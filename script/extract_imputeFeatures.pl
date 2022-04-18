#!/usr/bin/perl -w
use strict;
use warnings;
use Getopt::Std;
use File::Path;
use File::Spec;
use FindBin qw($Bin $Script);
our %opts = (n=>'0',c=>'N');
getopts('f:s:o:',\%opts);

die "perl $0
          STD  output
          -f   <imputed vcf file prefix>
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

my %newarr;
foreach my $chr(1..22){
    if(-e "$opts{'f'}.chr$chr.vcf.gz"){
        open IN2,"gzip -dc $opts{'f'}.chr$chr.vcf.gz|";
        while (<IN2>){
            next if $_=~/^#/;
            chomp;
            my @arr=split(/\t/);
            next unless $included{"$arr[0]\t$arr[1]\t$arr[1]\t$arr[3]\t$arr[4]"};
            next if $arr[9]=~/^0\|0/;
            $newarr{"$arr[0]\t$arr[1]\t$arr[1]\t$arr[3]\t$arr[4]"}=1;
        }
        close IN2;
    }
}
open OUT,">$opts{o}" or die $!;
print OUT "Chr\tPos\tRef\tAlt\tImpute\n";
open IN1,"$opts{s}" or die $!;
while (my $line=<IN1>){
    chomp($line);
    my @arr=split(/\t/,$line);
    if($newarr{$line}){
        print OUT "$arr[0]\t$arr[1]\t$arr[3]\t$arr[4]\t1\n";
    }else{
        print OUT "$arr[0]\t$arr[1]\t$arr[3]\t$arr[4]\t0\n";
    }
}
close IN1;
close OUT;
