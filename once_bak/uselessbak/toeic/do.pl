#!/usr/perl -w
use strict;

open FILE, "t.txt";
my $str = "";
my $i = 0;
while(<FILE>) {
    my @ar = split('\t', $_);
    #print $ar[0];

    chop($ar[1]);
   # print $ar[1]  ;

    my $ho = '';
     if(0 == $i) {
         $ho = 'odd';
     } else {
        $ho = 'even';
     }

    $str .= '<li class="' . $ho . '"><strong>' . $ar[0] . '</strong><span>' . $ar[1] . '</span></li>' . "\n";

    $i = ($i+1)%2;
}
close FILE;

open IN, ">output.txt";
print IN $str;
close IN;