#! /usr/bin/perl -w

use FindBin qw($Bin $Script);
use Getopt::Std;
use File::Path;
use File::Spec;
our %opts = (n=>'0',c=>'N');
getopts('f:o:',\%opts);

die "perl $0
          STD  output
          -f   <mutect2 vcf file>
          -o   filtered mutect2 vcf file\n" unless ($opts{'f'} && $opts{'o'});
$opts{'o'}  = File::Spec->rel2abs($opts{'o'});
my $ii=0;
my $dp_i=0;
open OUT,">$opts{'o'}" or die $!;
open IN,"$opts{'f'}" or die $!;
while (my $line=<IN>){
    if($line=~/^#/){
        print OUT $line;
	if($line=~/##INFO=<ID=/){
		$line=~s/,.*//;
		$line=~s/##INFO=<ID=//;
		if($line eq "DP"){
			$dp_i=$ii;
		}
		$ii+=1;
	}
        next;
    }
    chomp($line);
    my @arr=split(/\t/,$line);
    next if length($arr[3]) > 1 || length($arr[4]) > 1;
    my $dp=(split(/;/, $arr[7]))[$dp_i];
    $dp=~s/DP=//;
    next if $dp <= 10;
    my $ad_ref=(split(/:/, $arr[9]))[1];
    $ad_ref=~s/,.*//;
    next if $ad_ref == 0;
    print OUT "$line\n";
}
close IN;
close OUT;
